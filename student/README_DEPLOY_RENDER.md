Deployment to Render.com (Docker)

Steps:

1. Store secrets in Render's Environment Variables (or use a private secrets store):

- `DB_URL` — JDBC URL for your database. Example: `jdbc:mysql://<host>:3306/student_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true`
- `DB_USER` — DB username
- `DB_PASSWORD` — DB password
- `DB_DRIVER` — JDBC driver class (default `com.mysql.cj.jdbc.Driver`)
- `SECRET_KEY` — application secret for signing/csrf (any random string)
- `ADMIN_USER` / `ADMIN_PASS` — optional admin credentials

2. Deploy via Render:

- Push this repo to GitHub.
- In Render, create a new Web Service -> Connect Repo -> Select `render.yaml` or create a Docker web service and point it to `student/Dockerfile`.
- Add the environment variables listed above in the Render dashboard.

3. Optionally set up managed database (AWS RDS, Render Postgres/MySQL) and point `DB_URL` to it.

Notes:
- The application reads DB configuration from environment variables (see `com.student.util.DBConnection`).
- The Docker image builds the WAR using Maven and runs it on Tomcat as the root app.
