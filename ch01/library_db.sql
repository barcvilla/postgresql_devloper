create table publishers(publisher_id Character varying (6), name Character varying (30), url Character varying (80), constraint "pk_bug" primary key(publisher_id));
INSERT INTO publishers VALUES ('0201', 'Addison-Wesley', 'www.aw-bc.com');
INSERT INTO publishers VALUES ('0471', 'John Wiley & Sons', 'www.wiley.com');
INSERT INTO publishers VALUES ('0262', 'MIT Press', 'mitpress.mit.edu');
INSERT INTO publishers VALUES ('0596', 'O''Reilly', 'www.ora.com');
INSERT INTO publishers VALUES ('019', 'Oxford University Press', 'www.oup.co.uk');
INSERT INTO publishers VALUES ('013', 'Prentice Hall', 'www.phptr.com');
INSERT INTO publishers VALUES ('0679', 'Random House', 'www.randomhouse.com');
INSERT INTO publishers VALUES ('07434', 'Simon & Schuster', 'www.simonsays.com');
SELECT * FROM publishers;

create table authors(author_id character varying (4), name character varying (25), fname character varying (25), constraint "pk_author" primary key(author_id));
INSERT INTO authors VALUES ('ALEX', 'Alexander', 'Christopher');
INSERT INTO authors VALUES ('BROO', 'Brooks', 'Frederick P.');
INSERT INTO authors VALUES ('CORM', 'Cormen', 'Thomas H.');
INSERT INTO authors VALUES ('DATE', 'Date', 'C. J.');
INSERT INTO authors VALUES ('DARW', 'Darwen', 'Hugh');
INSERT INTO authors VALUES ('FEIN', 'Feiner', 'Steven K.');
INSERT INTO authors VALUES ('FLAN', 'Flanagan', 'David');
INSERT INTO authors VALUES ('FOLE', 'Foley', 'James D.');
INSERT INTO authors VALUES ('GAMM', 'Gamma', 'Erich');
INSERT INTO authors VALUES ('GARF', 'Garfinkel', 'Simson');
INSERT INTO authors VALUES ('HEIN', 'Hein', 'Trent R.');
INSERT INTO authors VALUES ('HELM', 'Helm', 'Richard');
INSERT INTO authors VALUES ('HOPC', 'Hopcroft', 'John E.');
INSERT INTO authors VALUES ('HUGH', 'Hughes', 'John F.');
INSERT INTO authors VALUES ('ISHI', 'Ishikawa', 'Sara');
INSERT INTO authors VALUES ('JOHN', 'Johnson', 'Ralph');
INSERT INTO authors VALUES ('KAHN', 'Kahn', 'David');
INSERT INTO authors VALUES ('KERN', 'Kernighan', 'Brian');
INSERT INTO authors VALUES ('KIDD', 'Kidder', 'Tracy');
INSERT INTO authors VALUES ('KNUT', 'Knuth', 'Donald E.');
INSERT INTO authors VALUES ('LEIS', 'Leiserson', 'Charles E.');
INSERT INTO authors VALUES ('MOTW', 'Motwani', 'Rajeev');
INSERT INTO authors VALUES ('NEME', 'Nemeth', 'Evi');
INSERT INTO authors VALUES ('RAYM', 'Raymond', 'Eric');
INSERT INTO authors VALUES ('RITC', 'Ritchie', 'Dennis');
INSERT INTO authors VALUES ('RIVE', 'Rivest', 'Ronald R.');
INSERT INTO authors VALUES ('SCHN', 'Schneier', 'Bruce');
INSERT INTO authors VALUES ('SEEB', 'Seebass', 'Scott');
INSERT INTO authors VALUES ('SILV', 'Silverstein', 'Murray');
INSERT INTO authors VALUES ('SNYD', 'Snyder', 'Garth');
INSERT INTO authors VALUES ('STEI', 'Stein', 'Clifford E.');
INSERT INTO authors VALUES ('STOL', 'Stoll', 'Clifford');
INSERT INTO authors VALUES ('STRA', 'Strassmann', 'Steven');
INSERT INTO authors VALUES ('STRO', 'Stroustrup', 'Bjarne');
INSERT INTO authors VALUES ('ULLM', 'Ullman', 'Jeffrey D.');
INSERT INTO authors VALUES ('VAND', 'van Dam', 'Andries');
INSERT INTO authors VALUES ('VLIS', 'Vlissides', 'John');
INSERT INTO authors VALUES ('WEIS', 'Weise', 'Daniel');
SELECT * FROM authors;

create table books (title character varying (60), isbn character varying (13), publisher_id character varying (6), price decimal (10,2), 
constraint "fk_publishers" foreign key(publisher_id) references publishers(publisher_id));
alter table books 
	add constraint "pk_books" primary key (isbn);
INSERT INTO Books VALUES ('A Guide to the SQL Standard', '0-201-96426-0', '0201', 47.95);
INSERT INTO Books VALUES ('A Pattern Language: Towns, Buildings, Construction', '0-19-501919-9', '019', 65.00);
INSERT INTO Books VALUES ('Applied Cryptography', '0-471-11709-9', '0471', 60.00);
INSERT INTO Books VALUES ('Computer Graphics: Principles and Practice', '0-201-84840-6', '0201', 79.99);
INSERT INTO Books VALUES ('Cuckoo''s Egg', '0-7434-1146-3', '07434', 13.95);
INSERT INTO Books VALUES ('Design Patterns', '0-201-63361-2', '0201', 54.99);
INSERT INTO Books VALUES ('Introduction to Algorithms', '0-262-03293-7', '0262', 80.00);
INSERT INTO Books VALUES ('Introduction to Automata Theory, Languages, and Computation', '0-201-44124-1', '0201', 105.00);
INSERT INTO Books VALUES ('JavaScript: The Definitive Guide', '0-596-00048-0', '0596', 44.95);
INSERT INTO Books VALUES ('The Art of Computer Programming vol. 1', '0-201-89683-4', '0201', 59.99);
INSERT INTO Books VALUES ('The Art of Computer Programming vol. 2', '0-201-89684-2', '0201', 59.99);
INSERT INTO Books VALUES ('The Art of Computer Programming vol. 3', '0-201-89685-0', '0201', 59.99);
INSERT INTO Books VALUES ('The C Programming Language', '0-13-110362-8', '013', 42.00);
INSERT INTO Books VALUES ('The C++ Programming Language', '0-201-70073-5', '0201', 64.99);
INSERT INTO Books VALUES ('The Cathedral and the Bazaar', '0-596-00108-8', '0596', 16.95);
INSERT INTO Books VALUES ('The Codebreakers', '0-684-83130-9', '07434', 70.00);
INSERT INTO Books VALUES ('The Mythical Man-Month', '0-201-83595-9', '0201', 29.95);
INSERT INTO Books VALUES ('The Soul of a New Machine', '0-679-60261-5', '0679', 18.95);
INSERT INTO Books VALUES ('The UNIX Hater''s Handbook', '1-56884-203-1', '0471', 16.95);
INSERT INTO Books VALUES ('UNIX System Administration Handbook', '0-13-020601-6', '013', 68.00);
SELECT * FROM Books

create table booksauthors (isbn character varying(13), author_id character varying(4), seq_no integer,
constraint "fk_isbn" foreign key(isbn) references books (isbn),
constraint "fk_author" foreign key(author_id) references authors(author_id))
INSERT INTO BooksAuthors VALUES ('0-201-96426-0', 'DATE', 1);
INSERT INTO BooksAuthors VALUES ('0-201-96426-0', 'DARW', 2);
INSERT INTO BooksAuthors VALUES ('0-19-501919-9', 'ALEX', 1);
INSERT INTO BooksAuthors VALUES ('0-19-501919-9', 'ISHI', 2);
INSERT INTO BooksAuthors VALUES ('0-19-501919-9', 'SILV', 3);
INSERT INTO BooksAuthors VALUES ('0-471-11709-9', 'SCHN', 1);
INSERT INTO BooksAuthors VALUES ('0-201-84840-6', 'FOLE', 1);
INSERT INTO BooksAuthors VALUES ('0-201-84840-6', 'VAND', 2);
INSERT INTO BooksAuthors VALUES ('0-201-84840-6', 'FEIN', 3);
INSERT INTO BooksAuthors VALUES ('0-201-84840-6', 'HUGH', 4);
INSERT INTO BooksAuthors VALUES ('0-7434-1146-3', 'STOL', 1);
INSERT INTO BooksAuthors VALUES ('0-201-63361-2', 'GAMM', 1);
INSERT INTO BooksAuthors VALUES ('0-201-63361-2', 'HELM', 2);
INSERT INTO BooksAuthors VALUES ('0-201-63361-2', 'JOHN', 3);
INSERT INTO BooksAuthors VALUES ('0-201-63361-2', 'VLIS', 4);
INSERT INTO BooksAuthors VALUES ('0-262-03293-7', 'CORM', 1);
INSERT INTO BooksAuthors VALUES ('0-262-03293-7', 'LEIS', 2);
INSERT INTO BooksAuthors VALUES ('0-262-03293-7', 'RIVE', 3);
INSERT INTO BooksAuthors VALUES ('0-262-03293-7', 'STEI', 4);
INSERT INTO BooksAuthors VALUES ('0-201-44124-1', 'HOPC', 1);
INSERT INTO BooksAuthors VALUES ('0-201-44124-1', 'ULLM', 2);
INSERT INTO BooksAuthors VALUES ('0-201-44124-1', 'MOTW', 3);
INSERT INTO BooksAuthors VALUES ('0-596-00048-0', 'FLAN', 1);
INSERT INTO BooksAuthors VALUES ('0-201-89683-4', 'KNUT', 1);
INSERT INTO BooksAuthors VALUES ('0-201-89684-2', 'KNUT', 1);
INSERT INTO BooksAuthors VALUES ('0-201-89685-0', 'KNUT', 1);
INSERT INTO BooksAuthors VALUES ('0-13-110362-8', 'KERN', 1);
INSERT INTO BooksAuthors VALUES ('0-13-110362-8', 'RITC', 2);
INSERT INTO BooksAuthors VALUES ('0-201-70073-5', 'STRO', 1);
INSERT INTO BooksAuthors VALUES ('0-596-00108-8', 'RAYM', 1);
INSERT INTO BooksAuthors VALUES ('0-684-83130-9', 'KAHN', 1);
INSERT INTO BooksAuthors VALUES ('0-201-83595-9', 'BROO', 1);
INSERT INTO BooksAuthors VALUES ('0-679-60261-5', 'KIDD', 1);
INSERT INTO BooksAuthors VALUES ('1-56884-203-1', 'GARF', 1);
INSERT INTO BooksAuthors VALUES ('1-56884-203-1', 'WEIS', 2);
INSERT INTO BooksAuthors VALUES ('1-56884-203-1', 'STRA', 3);
INSERT INTO BooksAuthors VALUES ('0-13-020601-6', 'NEME', 1);
INSERT INTO BooksAuthors VALUES ('0-13-020601-6', 'SNYD', 2);
INSERT INTO BooksAuthors VALUES ('0-13-020601-6', 'SEEB', 3);
INSERT INTO BooksAuthors VALUES ('0-13-020601-6', 'HEIN', 4);
SELECT * FROM BooksAuthors;



