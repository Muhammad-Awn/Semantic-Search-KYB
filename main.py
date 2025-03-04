from fastapi import FastAPI, Query
from sentence_transformers import SentenceTransformer
from pinecone import Pinecone
from creds import Pinecone_API
import os

# Initialize FastAPI
app = FastAPI()

# Load embedding model (use the same model as used for indexing)
model = SentenceTransformer("all-MiniLM-L6-v2")

# Initialize Pinecone
pc =Pinecone(api_key=Pinecone_API)

# Connect to the Pinecone index
index = pc.Index("semantic-search")

@app.get("/search")
def search_sentence(query: str = Query(...)):
    # Convert query sentence to vector embedding
    query_embedding = model.encode([query]).tolist()

    # Perform search in Pinecone
    result = index.query(vector=query_embedding[0], top_k=1, include_metadata=True)

    if result and "matches" in result and result["matches"]:
        print(result["matches"][0]["metadata"]["text"])
        best_match = result["matches"][0]["metadata"]["text"]
    else:
        best_match = "No matching text found."

    return {"best_match": best_match}
