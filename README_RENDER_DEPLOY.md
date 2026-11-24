# 🚀 Hydro HRMS & Attendance Platform - Render Cloud Deployment Guide

This package contains the **complete production codebase** and **full PostgreSQL schema** (all 61 tables, indexes, views, and relationships) with zero personal data, ready for immediate cloud deployment on [Render](https://render.com).

---

## 📦 What is Inside this Clean Package

| Directory / File | Description |
|---|---|
| `backend/` | Complete Node.js Express REST API, Socket.IO live tracking engine, geofencing, and payroll services. |
| `frontend/` | Complete React 19 + Vite dashboard source code. |
| `frontend/dist/` | Pre-compiled, production-ready static assets with all latest UI updates (equal-width badges, centered text, dark/light themes). |
| `schema.sql` | Complete PostgreSQL database schema (all 61 tables, sequences, constraints, and views) dumped directly from production PostgreSQL. |
| `render.yaml` | Render Blueprint file for 1-click automated deployment of both PostgreSQL database and Web Service. |
| `storage/` & `uploads/` | Clean runtime folder structure with `.gitkeep` for cloud file handling. |

---

## ⚡ Deployment Option 1: 1-Click Render Blueprint (Easiest & Fastest)

Render can automatically provision the PostgreSQL database and the web service together using the included `render.yaml`:

1. **Push this unzipped folder to your GitHub / GitLab repository**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit of clean Hydro platform"
   git branch -M main
   git remote add origin https://github.com/<YOUR_USERNAME>/<YOUR_REPO_NAME>.git
   git push -u origin main
   ```

2. **Open Render Dashboard**:
   - Go to [dashboard.render.com](https://dashboard.render.com).
   - Click the **"New +"** button in the top right.
   - Select **"Blueprint"**.
   - Connect your GitHub repository.
   - Render will read `render.yaml` and show:
     - **Database**: `hydro-hrms-db` (PostgreSQL)
     - **Web Service**: `hydro-hrms-app` (Node Web Service)
   - Click **"Apply"**.

3. **Import the Table Structure (`schema.sql`)**:
   Once the database is created in Render:
   - Go to your database dashboard on Render (`hydro-hrms-db`).
   - Copy the **External Database URL** (e.g. `postgres://hydro_admin:...@dpg-xxx.oregon-postgres.render.com/hydro_hrms`).
   - Run this single command in your terminal / PowerShell to import all 61 tables:
     ```bash
     psql "<YOUR_EXTERNAL_DATABASE_URL>" -f schema.sql
     ```
     *(Alternatively, open DBeaver, pgAdmin, or Render's web shell and paste the contents of `schema.sql`)*.

4. **Your Live Link is Ready**:
   Render will provide your live URL (e.g., `https://hydro-hrms-app.onrender.com`).
   - Frontend, API, and Sockets all run smoothly on this link!

---

## 🛠 Deployment Option 2: Manual Step-by-Step Setup on Render

If you prefer setting up services individually:

### Step 1: Create PostgreSQL Database on Render
1. In Render Dashboard, click **New +** -> **PostgreSQL**.
2. Name: `hydro-hrms-db`
3. Database Name: `hydro_hrms`
4. User: `hydro_admin`
5. Plan: **Free** or **Starter**.
6. Click **Create Database**.
7. Once created, copy the **Internal Database URL** (for connecting inside Render) and **External Database URL** (for importing `schema.sql`).
8. Run `psql "<EXTERNAL_DATABASE_URL>" -f schema.sql` to create all 61 tables.

### Step 2: Create Web Service on Render
1. Click **New +** -> **Web Service**.
2. Connect your GitHub repository.
3. Configure the settings:
   - **Environment**: `Node`
   - **Build Command**:
     ```bash
     npm install --prefix backend && npm install --prefix frontend && npm run build --prefix frontend
     ```
   - **Start Command**:
     ```bash
     node backend/src/server.js
     ```
4. Add Environment Variables:
   | Key | Value | Description |
   |---|---|---|
   | `NODE_ENV` | `production` | Production mode |
   | `PORT` | `8000` | Port for Express server |
   | `DB_DIALECT` | `postgres` | Use PostgreSQL engine |
   | `DATABASE_URL` | `<PASTE_INTERNAL_DATABASE_URL>` | From Step 1 |
   | `JWT_SECRET` | `<GENERATE_ANY_RANDOM_SECRET_KEY>` | e.g. `hydro_jwt_secret_2026_xyz` |
   | `ALLOWED_ORIGINS` | `*` | Allow all browser origins |

5. Click **Create Web Service**.
6. Render builds the project and deploys your live app at: `https://<YOUR_APP_NAME>.onrender.com`!

---

## 👥 Adding Your 2 Dummy Employees
Once live, log in to the dashboard using your admin account or create an admin user, then:
1. Navigate to **HRMS -> Employees**.
2. Click **"+ Add Employee"**.
3. Create your 2 dummy employees (e.g. Employee 1 and Employee 2) with their mobile punch credentials.
4. Assign them to Geofences in **HRMS -> Geofences** if you wish to test live attendance tracking.
