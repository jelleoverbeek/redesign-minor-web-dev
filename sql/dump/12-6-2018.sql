-- Adminer 4.6.2 PostgreSQL dump

DROP TABLE IF EXISTS "course";
DROP SEQUENCE IF EXISTS course_id_seq;
CREATE SEQUENCE course_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."course" (
    "id" integer DEFAULT nextval('course_id_seq') NOT NULL,
    "name" character varying NOT NULL,
    "description" character varying NOT NULL,
    "partner_id" integer,
    "type_id" integer NOT NULL,
    "active" boolean NOT NULL,
    CONSTRAINT "course_pk" PRIMARY KEY ("id"),
    CONSTRAINT "course_partner_id_fkey" FOREIGN KEY (partner_id) REFERENCES partner(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "course_type_id_fkey" FOREIGN KEY (type_id) REFERENCES course_type(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

INSERT INTO "course" ("id", "name", "description", "partner_id", "type_id", "active") VALUES
(5,	'Project 1',	'Projectweek 1 for the public library of Amsterdam',	1,	1,	'1'),
(4,	'Web Design',	'Design like a pro',	NULL,	3,	'1'),
(3,	'CSS To The Rescue',	'How to Pleasurable by Vasilis',	NULL,	3,	'1');

DROP VIEW IF EXISTS "course_overview_view";
CREATE TABLE "course_overview_view" ("course_name" character varying, "course_type" character varying(255), "teacher_name" character varying(255), "teacher_repository" character varying(512), "teacher_website" character varying(512), "teacher_avatar" character varying(512), "partner_name" character varying(255), "partner_website" character varying, "partner_logo" character varying);


DROP VIEW IF EXISTS "course_timeline_view";
CREATE TABLE "course_timeline_view" ("course_name" character varying, "course_type" character varying(255), "teacher_name" character varying(255), "teacher_repository" character varying(512), "teacher_website" character varying(512), "teacher_avatar" character varying(512), "weeks" json);


DROP TABLE IF EXISTS "course_type";
DROP SEQUENCE IF EXISTS course_type_id_seq;
CREATE SEQUENCE course_type_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."course_type" (
    "id" integer DEFAULT nextval('course_type_id_seq') NOT NULL,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "course_type_id" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "course_type" ("id", "name") VALUES
(1,	'PROJECT'),
(2,	'WEEKLY_NERD'),
(3,	'COURSE');

DROP TABLE IF EXISTS "course_week";
CREATE TABLE "public"."course_week" (
    "course_id" integer NOT NULL,
    "week_number" smallint NOT NULL,
    "description" character varying(512),
    CONSTRAINT "course_weeks_composite_pk" PRIMARY KEY ("course_id", "week_number"),
    CONSTRAINT "course_weeks_course_id_fkey" FOREIGN KEY (course_id) REFERENCES course(id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

INSERT INTO "course_week" ("course_id", "week_number", "description") VALUES
(3,	1,	'CSS startup'),
(3,	2,	'Just use weird selectors'),
(3,	3,	'Time to finish everything up :)');

DROP TABLE IF EXISTS "partner";
DROP SEQUENCE IF EXISTS partner_id_seq;
CREATE SEQUENCE partner_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."partner" (
    "id" integer DEFAULT nextval('partner_id_seq') NOT NULL,
    "name" character varying(255) NOT NULL,
    "logo_url" character varying NOT NULL,
    "website_url" character varying,
    CONSTRAINT "partner_pk" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "partner" ("id", "name", "logo_url", "website_url") VALUES
(1,	'Public Library of Amsterdam',	'http://www.thonik.nl/app/uploads/07-thonik-amsterdam-openbare_bibliotheek_amsterdam_OBA-library-logo_uitleg-filmstill-1440x810.jpg',	'https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjb3InB48vbAhVCVxQKHTsdATYQFggpMAA&url=https%3A%2F%2Fwww.oba.nl%2F&usg=AOvVaw06a4oMxeuReoEHbO8YMRqX');

DROP TABLE IF EXISTS "student_work";
DROP SEQUENCE IF EXISTS student_work_id_seq;
CREATE SEQUENCE student_work_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."student_work" (
    "id" integer DEFAULT nextval('student_work_id_seq') NOT NULL,
    "student_name" character varying(255) NOT NULL,
    "title" character varying(255) NOT NULL,
    "repository_url" character varying(512),
    "demo_url" character varying(512),
    "course_id" integer NOT NULL,
    CONSTRAINT "student_work_pk" PRIMARY KEY ("id"),
    CONSTRAINT "student_work_course_id_fkey" FOREIGN KEY (course_id) REFERENCES course(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);


DROP TABLE IF EXISTS "teacher";
DROP SEQUENCE IF EXISTS teacher_teacher_id_seq;
CREATE SEQUENCE teacher_teacher_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."teacher" (
    "id" integer DEFAULT nextval('teacher_teacher_id_seq') NOT NULL,
    "type" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "repository_url" character varying(512),
    "website_url" character varying(512),
    "avatar_url" character varying(512) NOT NULL,
    CONSTRAINT "teacher_pk" PRIMARY KEY ("id"),
    CONSTRAINT "teacher_teacher_id_fkey" FOREIGN KEY (id) REFERENCES teacher_type(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

INSERT INTO "teacher" ("id", "type", "name", "repository_url", "website_url", "avatar_url") VALUES
(1,	1,	'Vasilis van Gemert',	'https://github.com/vasilisvg',	'http://vasilis.nl/',	'https://a11yrules.com/wp-content/uploads/2018/01/Vasilis-van-Gemert.jpg');

DROP TABLE IF EXISTS "teacher_course";
CREATE TABLE "public"."teacher_course" (
    "teacher_id" integer NOT NULL,
    "course_id" integer NOT NULL,
    CONSTRAINT "teacher_course_composite_pk" PRIMARY KEY ("teacher_id", "course_id"),
    CONSTRAINT "teacher_course_course_id_fkey" FOREIGN KEY (course_id) REFERENCES course(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE,
    CONSTRAINT "teacher_course_teacher_id_fkey" FOREIGN KEY (teacher_id) REFERENCES teacher(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE
) WITH (oids = false);

INSERT INTO "teacher_course" ("teacher_id", "course_id") VALUES
(1,	3),
(1,	4);

DROP TABLE IF EXISTS "teacher_type";
DROP SEQUENCE IF EXISTS teacher_type_teacher_type_id_seq;
CREATE SEQUENCE teacher_type_teacher_type_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."teacher_type" (
    "id" integer DEFAULT nextval('teacher_type_teacher_type_id_seq') NOT NULL,
    "name" character varying(255) NOT NULL,
    CONSTRAINT "teacher_type_pk" PRIMARY KEY ("id")
) WITH (oids = false);

INSERT INTO "teacher_type" ("id", "name") VALUES
(1,	'TEACHER'),
(2,	'GUEST_SPEAKER');

DROP TABLE IF EXISTS "testimonial";
DROP SEQUENCE IF EXISTS testimonial_id_seq;
CREATE SEQUENCE testimonial_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."testimonial" (
    "id" integer DEFAULT nextval('testimonial_id_seq') NOT NULL,
    "name" integer NOT NULL,
    "role" character varying NOT NULL,
    "message" text NOT NULL,
    CONSTRAINT "testimonial_pk" PRIMARY KEY ("id")
) WITH (oids = false);


DROP TABLE IF EXISTS "course_overview_view";
CREATE TABLE "public"."course_overview_view" (
    "course_name" character varying,
    "course_type" character varying(255),
    "teacher_name" character varying(255),
    "teacher_repository" character varying(512),
    "teacher_website" character varying(512),
    "teacher_avatar" character varying(512),
    "partner_name" character varying(255),
    "partner_website" character varying,
    "partner_logo" character varying
) WITH (oids = false);

DROP TABLE IF EXISTS "course_timeline_view";
CREATE TABLE "public"."course_timeline_view" (
    "course_name" character varying,
    "course_type" character varying(255),
    "teacher_name" character varying(255),
    "teacher_repository" character varying(512),
    "teacher_website" character varying(512),
    "teacher_avatar" character varying(512),
    "weeks" json
) WITH (oids = false);

-- 2018-06-11 16:45:26.408709+00
