from flask import Flask 
import logging

app= Flask(__name__)
logging.basicConfig(level=logging.INFO)

@app.route("/")
def home ():
    logging.info("Health check received on / endpoint")
    return "Hello from ECS Fargate DevOps Lab!"

@app.route("/health")
def health():
    logging.info("Health check received on /health endpoint")
    return "healthy" , 200 

if __name__ == "__main__":
    logging.info("Starting Flask application")
    app.run(host="0.0.0.0" , port=5000)
