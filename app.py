from flask import Flask, render_template
import os

app = Flask(__name__)

PROFILE_DATA = {
    "name": "Anushka",
    "role": "DevOps & MLOps Engineer",
    "linkedin": "https://www.linkedin.com/in/your-profile",
    "resume_link": "https://your-s3-bucket-link.s3.amazonaws.com/resume.pdf",
    "image_url": "https://your-s3-bucket-link.s3.amazonaws.com/profile-pic.jpg"
}

@app.route('/')
def home():
    return render_template('index.html', data=PROFILE_DATA)

if __name__ == '__main__':
    # Using port 80 for AWS EC2 deployment as per Task 2
    port = int(os.environ.get('PORT', 80))
    app.run(host='0.0.0.0', port=port)
