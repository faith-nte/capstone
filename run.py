from app import create_app, db
from app.models import Contact

# Prometheus client imports
from prometheus_client import generate_latest, CONTENT_TYPE_LATEST, Summary
from flask import Response

app = create_app()

# Optional: Define a custom metric
REQUEST_TIME = Summary('request_processing_seconds', 'Time spent processing request')

# Expose /metrics endpoint
@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)

@app.route('/')
@REQUEST_TIME.time()
def index():
    return "Welcome to the Address Book App!"

if __name__ == "__main__":
    with app.app_context():
        db.create_all()  # Create tables
    app.run(debug=True, host="0.0.0.0", port=5000)
