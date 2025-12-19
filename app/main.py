"""
Simple FastAPI app with health check.
"""

from fastapi import FastAPI

app = FastAPI() 

@app.get("/")
def root():
    return {"message": "Hello from Fargate"}

@app.get("/health")
def health():
    return {"status": "ok"}
