# 🕌 KnowYourBooks – Islamic Text Verifier 📖

![Flutter](https://img.shields.io/badge/Flutter-Framework-blue?logo=flutter)
![FastAPI](https://img.shields.io/badge/FastAPI-Backend-green?logo=fastapi)
![Pinecone](https://img.shields.io/badge/Pinecone-Vector_DB-blueviolet)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

> **A mobile app to verify Islamic quotes using semantic search powered by AI.**

---

## 📱 Demo

<p align="center">
  <img src="assets/screenshot1.png" alt="Search UI" width="250"/>
  <img src="assets/screenshot2.png" alt="Results UI" width="250"/>
</p>

---

## 📌 Features

- 🔍 Enter any Islamic quote or claim
- 📖 Search for closest matching verse or hadith
- 📊 View semantic match score
- ⚡ Fast and lightweight (optimized for mobile and API efficiency)

---

## 🧠 Tech Stack

### 💡 Frontend (Flutter)
- Cross-platform mobile UI
- Text input field + Search button
- Consumes REST API to show results

### 🛠 Backend (FastAPI)
- Accepts query via `/search` endpoint
- Converts query to vector embedding
- Performs similarity search in Pinecone vector DB

### 🧬 Embeddings Model
- [`all-MiniLM-L6-v2`](https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2) (384-dimensions)
- Served using [`txtai`](https://github.com/neuml/txtai) for lightweight deployment

### 🔎 Vector Search
- [`Pinecone`](https://www.pinecone.io/) for fast semantic similarity indexing
- Indexed corpus of Qur’an verses and hadith texts

---

## 🎯 Project Intent

> To **verify Islamic quotes and claims** by checking them against **original scriptures**, and return the **closest semantic match** with a **confidence score**.

This app helps:
- Prevent **misattribution** of quotes to Qur’an or Hadith
- Encourage **authentic learning**
- Assist **students, educators, and seekers** of Islamic knowledge

---

## 🚀 Getting Started

### 📦 Backend Setup

1. **Clone the repo**
```bash
git clone https://github.com/your-username/knowyourbooks.git
cd knowyourbooks/backend
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Run FastAPI APP**
```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

4. **Access Swagger UI at:**
```bash
http://127.0.0.1:8000/docs
```

## 🙏 Acknowledgements

We gratefully acknowledge the open-source tools and communities that made this project possible:

- 📚 Hugging Face – For providing the all-MiniLM-L6-v2 embedding model
- 🔎 Pinecone – For fast and scalable vector similarity search
- ⚡ FastAPI – For building the backend RESTful API
- 📱 Flutter – For creating a performant and beautiful mobile UI


## 🤝 Contributions

We welcome your contributions to make KnowYourBooks better for everyone! You can contribute by:

- 🧠 Improving the semantic search accuracy or choosing better embedding models

- 📖 Expanding the dataset with additional verified Islamic texts (with sources)

- 🛠 Refining the Flutter UI/UX

- 🌐 Translating the app into other languages

- 🐞 Reporting issues or submitting feature requests

- ✍️ Writing documentation or educational guides

---

📬 For questions, suggestions, or contributions, feel free to open an issue or email at muhammadawn24@gmail.com
