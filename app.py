from flask import Flask, render_template
import os

app = Flask(__name__)

PROFILE_DATA = {
    "name": "Anushka Jaiswal",
    "role": "DevOps & MLOps Engineer",
    "linkedin": "https://www.linkedin.com/in/anushka-jaiswal-/",
    "resume_link": "https://anuska-portfolio-assets-mumbai-2026.s3.ap-south-1.amazonaws.com/resume.pdf.pdf",
    "image_url": "https://anuska-portfolio-assets-mumbai-2026.s3.ap-south-1.amazonaws.com/profile.jpeg"
}

@app.route('/')
def home():
    return render_template('index.html', data=PROFILE_DATA)

if __name__ == '__main__':
    # Using port 80 for AWS EC2 deployment as per Task 2
    port = int(os.environ.get('PORT', 80))
    app.run(host='0.0.0.0', port=port)
