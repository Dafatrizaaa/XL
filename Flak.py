import os
from flask import Flask, render_template, request, redirect, url_for, send_from_directory, flash
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required, current_user
from werkzeug.utils import secure_filename

# Konfigurasi Flask
app = Flask(__name__)
app.secret_key = "$SECRET_KEY"

# Konfigurasi folder upload
UPLOAD_FOLDER = 'uploads'
TEMPLATES_FOLDER = 'templates'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Ekstensi file yang diizinkan
ALLOWED_EXTENSIONS = {'html, 'zip', 'rar', 'iso', 'img', 'avi', 'svg', 'sh', 'gz', 'mp3', 'txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif', 'mp4', 'mkv'}

# Login manager setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = "login"

# Dummy user database
users = {"a@#dm1/n": "@nDr0id/$8k@Q"}
REGISTER_CODE = "$CODE"

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
            flash('Invalid username or password', 'danger')
    return render_template('login.html')

# Rute untuk pendaftaran
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        code = request.form['code']
        
        if code != REGISTER_CODE:
            flash('❌ Registration code salah.', 'danger')
            return redirect(url_for('register'))
        
        if username in users:
            flash('❗Username sudah ada.', 'warning')
        else:
            users[username] = password
            flash('✅ Registrasi akun berhasil.', 'success')
        
    return render_template('register.html')
    
# Rute untuk dashboard
@app.route('/dashboard')
@login_required
def dashboard():
    files = os.listdir(app.config['UPLOAD_FOLDER'])
    return render_template('dashboard.html', files=files)

# Rute untuk mengunggah file
@app.route('/upload', methods=['POST'])
@login_required
def upload_file():
    if 'file' not in request.files:
        flash('No file part in the request', 'danger')
        return redirect(url_for('dashboard'))
    file = request.files['file']
    if file.filename == '':
        flash('No selected file', 'warning')
        return redirect(url_for('dashboard'))
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        try:
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            flash('File successfully uploaded', 'success')
        except Exception as e:
            flash(f'File upload failed: {str(e)}', 'danger')
        return redirect(url_for('dashboard'))
    else:
        flash('File type not allowed', 'danger')
        return redirect(url_for('dashboard'))

# Rute untuk mengunduh file
@app.route('/get/<filename>')
def download_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

# Rute untuk logout
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=$PORT, debug=True)
