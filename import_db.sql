CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(30) NOT NULL,
  lname VARCHAR(30) NOT NULL,
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  users_id INTEGER NOT NULL,

  FOREIGN KEY(questions_id) REFERENCES questions(id)
  FOREIGN KEY(users_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  questions_id INTEGER NOT NULL,
  reply_id INTEGER,
  author_id INTEGER NOT NULL,
  reply_body TEXT NOT NULL,

  FOREIGN KEY(questions_id) REFERENCES questions(id)
  FOREIGN KEY(reply_id) REFERENCES replies(id)
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE questions_like (
  id INTEGER PRIMARY KEY,
  users_id INTEGER NOT NULL,
  questions_id INTEGER NOT NULL,

  FOREIGN KEY(questions_id) REFERENCES questions(id)
  FOREIGN KEY(users_id) REFERENCES users(id)
);
