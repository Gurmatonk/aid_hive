--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: commontator_comments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE commontator_comments (
    id integer NOT NULL,
    creator_type character varying,
    creator_id integer,
    editor_type character varying,
    editor_id integer,
    thread_id integer NOT NULL,
    body text NOT NULL,
    deleted_at timestamp without time zone,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_comments_id_seq OWNED BY commontator_comments.id;


--
-- Name: commontator_subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE commontator_subscriptions (
    id integer NOT NULL,
    subscriber_type character varying NOT NULL,
    subscriber_id integer NOT NULL,
    thread_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_subscriptions_id_seq OWNED BY commontator_subscriptions.id;


--
-- Name: commontator_threads; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE commontator_threads (
    id integer NOT NULL,
    commontable_type character varying,
    commontable_id integer,
    closed_at timestamp without time zone,
    closer_type character varying,
    closer_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commontator_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commontator_threads_id_seq OWNED BY commontator_threads.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE entries (
    id integer NOT NULL,
    title character varying,
    description text,
    street_name character varying,
    street_number character varying,
    postal_code character varying NOT NULL,
    city character varying NOT NULL,
    latitude double precision,
    longitude double precision,
    type character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id integer
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entries_id_seq OWNED BY entries.id;


--
-- Name: mailboxer_conversation_opt_outs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_conversation_opt_outs (
    id integer NOT NULL,
    unsubscriber_id integer,
    unsubscriber_type character varying,
    conversation_id integer
);


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_conversation_opt_outs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversation_opt_outs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_conversation_opt_outs_id_seq OWNED BY mailboxer_conversation_opt_outs.id;


--
-- Name: mailboxer_conversations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_conversations (
    id integer NOT NULL,
    subject character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_conversations_id_seq OWNED BY mailboxer_conversations.id;


--
-- Name: mailboxer_notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_notifications (
    id integer NOT NULL,
    type character varying,
    body text,
    subject character varying DEFAULT ''::character varying,
    sender_id integer,
    sender_type character varying,
    conversation_id integer,
    draft boolean DEFAULT false,
    notification_code character varying,
    notified_object_id integer,
    notified_object_type character varying,
    attachment character varying,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL,
    global boolean DEFAULT false,
    expires timestamp without time zone
);


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_notifications_id_seq OWNED BY mailboxer_notifications.id;


--
-- Name: mailboxer_receipts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mailboxer_receipts (
    id integer NOT NULL,
    receiver_id integer,
    receiver_type character varying,
    notification_id integer NOT NULL,
    is_read boolean DEFAULT false,
    trashed boolean DEFAULT false,
    deleted boolean DEFAULT false,
    mailbox_type character varying(25),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mailboxer_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailboxer_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mailboxer_receipts_id_seq OWNED BY mailboxer_receipts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    role integer,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying,
    invitations_count integer DEFAULT 0,
    street_name character varying,
    street_number character varying,
    city character varying,
    postal_code character varying,
    latitude double precision,
    longitude double precision
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_comments ALTER COLUMN id SET DEFAULT nextval('commontator_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_subscriptions ALTER COLUMN id SET DEFAULT nextval('commontator_subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commontator_threads ALTER COLUMN id SET DEFAULT nextval('commontator_threads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs ALTER COLUMN id SET DEFAULT nextval('mailboxer_conversation_opt_outs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversations ALTER COLUMN id SET DEFAULT nextval('mailboxer_conversations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_notifications ALTER COLUMN id SET DEFAULT nextval('mailboxer_notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_receipts ALTER COLUMN id SET DEFAULT nextval('mailboxer_receipts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: commontator_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commontator_comments
    ADD CONSTRAINT commontator_comments_pkey PRIMARY KEY (id);


--
-- Name: commontator_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commontator_subscriptions
    ADD CONSTRAINT commontator_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: commontator_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY commontator_threads
    ADD CONSTRAINT commontator_threads_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversation_opt_outs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs
    ADD CONSTRAINT mailboxer_conversation_opt_outs_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_conversations
    ADD CONSTRAINT mailboxer_conversations_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_notifications
    ADD CONSTRAINT mailboxer_notifications_pkey PRIMARY KEY (id);


--
-- Name: mailboxer_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mailboxer_receipts
    ADD CONSTRAINT mailboxer_receipts_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: entries_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx ON entries USING gin (to_tsvector('english'::regconfig, (title)::text));


--
-- Name: entries_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx1 ON entries USING gin (to_tsvector('english'::regconfig, description));


--
-- Name: entries_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx2 ON entries USING gin (to_tsvector('english'::regconfig, (street_name)::text));


--
-- Name: entries_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx3 ON entries USING gin (to_tsvector('english'::regconfig, (street_number)::text));


--
-- Name: entries_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx4 ON entries USING gin (to_tsvector('english'::regconfig, (postal_code)::text));


--
-- Name: entries_to_tsvector_idx5; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX entries_to_tsvector_idx5 ON entries USING gin (to_tsvector('english'::regconfig, (city)::text));


--
-- Name: index_commontator_comments_on_c_id_and_c_type_and_t_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_commontator_comments_on_c_id_and_c_type_and_t_id ON commontator_comments USING btree (creator_id, creator_type, thread_id);


--
-- Name: index_commontator_comments_on_cached_votes_down; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_commontator_comments_on_cached_votes_down ON commontator_comments USING btree (cached_votes_down);


--
-- Name: index_commontator_comments_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_commontator_comments_on_cached_votes_up ON commontator_comments USING btree (cached_votes_up);


--
-- Name: index_commontator_comments_on_thread_id_and_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_commontator_comments_on_thread_id_and_created_at ON commontator_comments USING btree (thread_id, created_at);


--
-- Name: index_commontator_subscriptions_on_s_id_and_s_type_and_t_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_commontator_subscriptions_on_s_id_and_s_type_and_t_id ON commontator_subscriptions USING btree (subscriber_id, subscriber_type, thread_id);


--
-- Name: index_commontator_subscriptions_on_thread_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_commontator_subscriptions_on_thread_id ON commontator_subscriptions USING btree (thread_id);


--
-- Name: index_commontator_threads_on_c_id_and_c_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_commontator_threads_on_c_id_and_c_type ON commontator_threads USING btree (commontable_id, commontable_type);


--
-- Name: index_entries_on_city; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_city ON entries USING btree (city);


--
-- Name: index_entries_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_latitude_and_longitude ON entries USING btree (latitude, longitude);


--
-- Name: index_entries_on_postal_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_postal_code ON entries USING btree (postal_code);


--
-- Name: index_entries_on_street_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_street_name ON entries USING btree (street_name);


--
-- Name: index_entries_on_street_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_street_number ON entries USING btree (street_number);


--
-- Name: index_entries_on_title; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_title ON entries USING btree (title);


--
-- Name: index_entries_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_type ON entries USING btree (type);


--
-- Name: index_entries_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_entries_on_user_id ON entries USING btree (user_id);


--
-- Name: index_mailboxer_conversation_opt_outs_on_conversation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_conversation_id ON mailboxer_conversation_opt_outs USING btree (conversation_id);


--
-- Name: index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type ON mailboxer_conversation_opt_outs USING btree (unsubscriber_id, unsubscriber_type);


--
-- Name: index_mailboxer_notifications_on_conversation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_conversation_id ON mailboxer_notifications USING btree (conversation_id);


--
-- Name: index_mailboxer_notifications_on_notified_object_id_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_notified_object_id_and_type ON mailboxer_notifications USING btree (notified_object_id, notified_object_type);


--
-- Name: index_mailboxer_notifications_on_sender_id_and_sender_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_sender_id_and_sender_type ON mailboxer_notifications USING btree (sender_id, sender_type);


--
-- Name: index_mailboxer_notifications_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_notifications_on_type ON mailboxer_notifications USING btree (type);


--
-- Name: index_mailboxer_receipts_on_notification_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_receipts_on_notification_id ON mailboxer_receipts USING btree (notification_id);


--
-- Name: index_mailboxer_receipts_on_receiver_id_and_receiver_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_mailboxer_receipts_on_receiver_id_and_receiver_type ON mailboxer_receipts USING btree (receiver_id, receiver_type);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invitations_count ON users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_latitude_and_longitude; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_latitude_and_longitude ON users USING btree (latitude, longitude);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: users_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_tsvector_idx ON users USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: users_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_tsvector_idx1 ON users USING gin (to_tsvector('english'::regconfig, (street_name)::text));


--
-- Name: users_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_tsvector_idx2 ON users USING gin (to_tsvector('english'::regconfig, (street_number)::text));


--
-- Name: users_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_tsvector_idx3 ON users USING gin (to_tsvector('english'::regconfig, (postal_code)::text));


--
-- Name: users_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX users_to_tsvector_idx4 ON users USING gin (to_tsvector('english'::regconfig, (city)::text));


--
-- Name: fk_rails_99dc12d4fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT fk_rails_99dc12d4fd FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: mb_opt_outs_on_conversations_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_conversation_opt_outs
    ADD CONSTRAINT mb_opt_outs_on_conversations_id FOREIGN KEY (conversation_id) REFERENCES mailboxer_conversations(id);


--
-- Name: notifications_on_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_notifications
    ADD CONSTRAINT notifications_on_conversation_id FOREIGN KEY (conversation_id) REFERENCES mailboxer_conversations(id);


--
-- Name: receipts_on_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mailboxer_receipts
    ADD CONSTRAINT receipts_on_notification_id FOREIGN KEY (notification_id) REFERENCES mailboxer_notifications(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151107204425');

INSERT INTO schema_migrations (version) VALUES ('20151107204426');

INSERT INTO schema_migrations (version) VALUES ('20151107204427');

INSERT INTO schema_migrations (version) VALUES ('20151107204430');

INSERT INTO schema_migrations (version) VALUES ('20151107204445');

INSERT INTO schema_migrations (version) VALUES ('20151107213903');

INSERT INTO schema_migrations (version) VALUES ('20151107214137');

INSERT INTO schema_migrations (version) VALUES ('20151107214905');

INSERT INTO schema_migrations (version) VALUES ('20151107234038');

INSERT INTO schema_migrations (version) VALUES ('20151114163318');

INSERT INTO schema_migrations (version) VALUES ('20151116192038');

INSERT INTO schema_migrations (version) VALUES ('20151116192039');

INSERT INTO schema_migrations (version) VALUES ('20151116192040');

