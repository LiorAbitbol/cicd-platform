"""
Simple FastAPI app with health check.
"""
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI(title="cicd-platform")


@app.get("/", response_class=HTMLResponse)
def root() -> str:
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>CI/CD Platform</title>
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen;
                background-color: #0f172a;
                color: #e5e7eb;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
                margin: 0;
            }
            .card {
                background: #020617;
                border: 1px solid #1e293b;
                padding: 2rem 3rem;
                border-radius: 8px;
                text-align: center;
                box-shadow: 0 10px 30px rgba(0,0,0,0.4);
            }
            h1 {
                margin-top: 0;
                color: #38bdf8;
            }
            p {
                margin-bottom: 0;
                opacity: 0.9;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>CI/CD Platform</h1>
            <p>Deployment successful.</p>
            <p>This service is running on AWS ECS Fargate.</p>
        </div>
    </body>
    </html>
    """


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}
