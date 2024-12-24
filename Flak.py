import os
import logging
import string
import random
from flask import Flask, render_template, request, redirect, url_for, send_from_directory, flash, jsonify, abort
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.utils import secure_filename
from werkzeug.middleware.proxy_fix import ProxyFix

# Konfigurasi Flask
app = Flask(__name__)
app.secret_key = os.getenv('SECRET_KEY', 'your_secret_key')

# Apply ProxyFix
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_port=1, x_prefix=1)

# Konfigurasi folder upload
UPLOAD_FOLDER = 'uploads'
TEMPLATES_FOLDER = 'templates'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# folder admin
admin_folder = os.path.join(app.config['UPLOAD_FOLDER'], 'Admin')
if not os.path.exists(admin_folder):
    os.makedirs(admin_folder)

# Ekstensi file yang diizinkan
ALLOWED_EXTENSIONS = {'html', 'zip', 'rar', 'iso', 'img', 'avi', 'svg', 'sh', 'gz', 'mp3', 'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mkv'}

# In-memory store for users and registration code usage
users = {
    "Admin": os.getenv('ADMIN_PASS', 'default_admin_pass')  # Menambahkan user admin dengan password default
}
REGISTER_CODE = "DK7H3-C7ANS-OBADQ-OIJM6-Z3SIQ"
register_code_usage = {REGISTER_CODE: 0}
MAX_REGISTRATIONS = 2

# Store for file access codes
file_access_codes = {}

# Setup logging
logging.basicConfig(level=logging.DEBUG)

# Login manager setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

class User(UserMixin):
    def __init__(self, id):
        self.id = id

@login_manager.user_loader
def load_user(user_id):
    if user_id in users:
        return User(user_id)
    return None

# Fungsi untuk memeriksa ekstensi file
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

# Fungsi untuk menghasilkan kode acak
def generate_random_code(length=8):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

# Rute untuk login
@app.route('/')
def home():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        if username in users and users[username] == password:
            user = User(username)
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username or password', 'erroruserpassword')
    return render_template('login.html')

# Rute untuk pendaftaran
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST']:
        username = request.form['username']
        password = request.form['password']
        reg_code = request.form['reg_code']

        if username in users:
            return jsonify({'success': False, 'message': '❗Username sudah ada.'})
        elif reg_code != REGISTER_CODE:
            return jsonify({'success': False, 'message': '❌ Registration code salah.'})
        elif register_code_usage[REGISTER_CODE] >= MAX_REGISTRATIONS:
            return jsonify({'success': False, 'message': '❌ Registration code expired.'})
        else:
            users[username] = password
            register_code_usage[REGISTER_CODE] += 1
            user_folder = os.path.join(app.config['UPLOAD_FOLDER'], username)
            if not os.path.exists(user_folder):
                os.makedirs(user_folder)
            return jsonify({'success': True, 'message': '✅ Registrasi akun berhasil.'})

    return render_template('register.html')

# Rute untuk dashboard
@app.route('/dashboard')
@login_required
def dashboard():
    user_folder = os.path.join(app.config['UPLOAD_FOLDER'], current_user.id)
    files = os.listdir(user_folder)
    file_links = {filename: f"/local/{code}" for code, filename in file_access_codes.items() if filename in files}
    return render_template('dashboard.html', files=files, file_links=file_links, users=users.keys())

# Rute untuk mengunggah file
@app.route('/upload', methods=['POST'])
@login_required
def upload_file():
    if 'file' not in request.files:
        logging.error('No file part in the request')
        return jsonify({'success': False, 'message': 'No file part in the request'})
    file = request.files['file']
    if file.filename == '':
        logging.warning('No selected file')
        return jsonify({'success': False, 'message': 'No selected file'})
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        user_folder = os.path.join(app.config['UPLOAD_FOLDER'], current_user.id)
        try:
            file.save(os.path.join(user_folder, filename))
            access_code = generate_random_code()
            file_access_codes[access_code] = filename
            logging.info(f'File successfully uploaded: {filename} with access code: {access_code}')
            return jsonify({'success': True, 'message': 'File successfully uploaded', 'access_code': access_code})
        except Exception as e:
            logging.error(f'File upload failed: {str(e)}')
            return jsonify({'success': False, 'message': f'File upload failed: {str(e)}'})
    else:
        logging.warning('File type not allowed')
        return jsonify({'success': False, 'message': 'File type not allowed'})

# Rute untuk mengunduh file dengan kode akses
@app.route('/local/<access_code>')
@login_required
def download_file(access_code):
    if access_code in file_access_codes:
        filename = file_access_codes[access_code]
        user_folder = os.path.join(app.config['UPLOAD_FOLDER'], current_user.id)
        return send_from_directory(user_folder, filename)
    else:
        abort(404)

# Rute untuk menghapus file
@app.route('/delete/<filename>', methods=['POST'])
@login_required
def delete_file(filename):
    user_folder = os.path.join(app.config['UPLOAD_FOLDER'], current_user.id)
    file_path = os.path.join(user_folder, filename)
    if os.path.exists(file_path):
        os.remove(file_path)
        logging.info(f'File successfully deleted: {filename}')
        return jsonify({'success': True, 'message': 'File successfully deleted'})
    else:
        logging.warning(f'File not found: {filename}')
        return jsonify({'success': False, 'message': 'File not found'})

# Rute untuk mengedit nama file
@app.route('/edit/<filename>', methods=['POST'])
@login_required
def edit_file(filename):
    new_name = request.form['new_name']
    if not allowed_file(new_name):
        logging.warning('File type not allowed')
        return jsonify({'success': False, 'message': 'File type not allowed'})
    user_folder = os.path.join(app.config['UPLOAD_FOLDER'], current_user.id)
    file_path = os.path.join(user_folder, filename)
    new_file_path = os.path.join(user_folder, new_name)
    if os.path.exists(file_path):
        os.rename(file_path, new_file_path)
        logging.info(f'File name successfully updated: {filename} to {new_name}')
        return jsonify({'success': True, 'message': 'File name successfully updated'})
    else:
        logging.warning(f'File not found: {filename}')
        return jsonify({'success': False, 'message': 'File not found'})

# Rute untuk logout
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.getenv('PORT', '17771')), debug=True)
