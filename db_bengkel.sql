PGDMP  	    %                |         
   db_bengkel     16.4 (Ubuntu 16.4-1.pgdg20.04+1)    16.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16541 
   db_bengkel    DATABASE     r   CREATE DATABASE db_bengkel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE db_bengkel;
                postgres    false            �            1255    16542    generate_kode()    FUNCTION     �   CREATE FUNCTION public.generate_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('kode_sequence')::text, 4, '0');
	RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.generate_kode();
       public          postgres    false            �            1255    16543    set_default_kode()    FUNCTION       CREATE FUNCTION public.set_default_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.kode IS NULL THEN
        NEW.kode := substr(regexp_replace(md5(random()::text || clock_timestamp()::text), '\D', '', 'g'), 1, 4);
    END IF;
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.set_default_kode();
       public          postgres    false            �            1255    16544    set_default_m_supplier_kode()    FUNCTION     �   CREATE FUNCTION public.set_default_m_supplier_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('m_supplier_kode_seq'::regclass)::text, 4, '1');
    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.set_default_m_supplier_kode();
       public          postgres    false            �            1259    16545    faktur_sequence    SEQUENCE     x   CREATE SEQUENCE public.faktur_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.faktur_sequence;
       public          postgres    false            �            1259    16546    kode_sequence    SEQUENCE     v   CREATE SEQUENCE public.kode_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.kode_sequence;
       public          postgres    false            �            1259    16547 
   m_customer    TABLE     &  CREATE TABLE public.m_customer (
    id integer NOT NULL,
    kode character varying(4) DEFAULT lpad((nextval('public.kode_sequence'::regclass))::text, 4, '0'::text),
    nama character varying(100) NOT NULL,
    nopol character varying(20),
    alamat text,
    no_hp character varying(15)
);
    DROP TABLE public.m_customer;
       public         heap    postgres    false    216            �            1259    16553    m_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_customer_id_seq;
       public          postgres    false    217            �           0    0    m_customer_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_customer_id_seq OWNED BY public.m_customer.id;
          public          postgres    false    218            �            1259    16554    m_item    TABLE       CREATE TABLE public.m_item (
    id integer NOT NULL,
    kode character varying(50),
    nama character varying(255),
    id_satuan integer,
    id_jenis_item integer,
    stok numeric(18,2) DEFAULT 0,
    hpp numeric,
    aktif boolean DEFAULT true,
    modal numeric
);
    DROP TABLE public.m_item;
       public         heap    postgres    false            �            1259    16561    m_item_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.m_item_id_seq;
       public          postgres    false    219            �           0    0    m_item_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.m_item_id_seq OWNED BY public.m_item.id;
          public          postgres    false    220            �            1259    16562    m_jenis_item_id_seq    SEQUENCE     |   CREATE SEQUENCE public.m_jenis_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.m_jenis_item_id_seq;
       public          postgres    false            �            1259    16563    m_jenis_item    TABLE     �   CREATE TABLE public.m_jenis_item (
    id integer DEFAULT nextval('public.m_jenis_item_id_seq'::regclass) NOT NULL,
    kode character varying(20),
    nama character varying(100)
);
     DROP TABLE public.m_jenis_item;
       public         heap    postgres    false    221            �            1259    16567    m_satuan_id_seq    SEQUENCE     x   CREATE SEQUENCE public.m_satuan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.m_satuan_id_seq;
       public          postgres    false            �            1259    16568    m_satuan    TABLE     �   CREATE TABLE public.m_satuan (
    id integer DEFAULT nextval('public.m_satuan_id_seq'::regclass) NOT NULL,
    nama character varying(50)
);
    DROP TABLE public.m_satuan;
       public         heap    postgres    false    223            �            1259    16572 
   m_supplier    TABLE     �   CREATE TABLE public.m_supplier (
    id integer NOT NULL,
    kode character varying(4),
    nama character varying(50) NOT NULL,
    no_hp character varying(20),
    alamat text,
    email character varying(30)
);
    DROP TABLE public.m_supplier;
       public         heap    postgres    false            �            1259    16577    m_supplier_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_supplier_id_seq;
       public          postgres    false    225            �           0    0    m_supplier_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_supplier_id_seq OWNED BY public.m_supplier.id;
          public          postgres    false    226            �            1259    16578    m_supplier_kode_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_kode_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1
    CYCLE;
 *   DROP SEQUENCE public.m_supplier_kode_seq;
       public          postgres    false            �            1259    16579    m_user    TABLE     �   CREATE TABLE public.m_user (
    id integer NOT NULL,
    pegawai character varying NOT NULL,
    username character varying NOT NULL,
    password text,
    id_role integer
);
    DROP TABLE public.m_user;
       public         heap    postgres    false            �            1259    16584    receipt_sequence    SEQUENCE     y   CREATE SEQUENCE public.receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.receipt_sequence;
       public          postgres    false            �            1259    16585    retur_receipt_sequence    SEQUENCE     �   CREATE SEQUENCE public.retur_receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;
 -   DROP SEQUENCE public.retur_receipt_sequence;
       public          postgres    false            �            1259    16586    retur_sales_sequence    SEQUENCE     }   CREATE SEQUENCE public.retur_sales_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.retur_sales_sequence;
       public          postgres    false            �            1259    16587    role    TABLE     n   CREATE TABLE public.role (
    id integer NOT NULL,
    kode character varying,
    nama character varying
);
    DROP TABLE public.role;
       public         heap    postgres    false            �            1259    16592    role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.role_id_seq;
       public          postgres    false    232            �           0    0    role_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;
          public          postgres    false    233            �            1259    16593    t_retur_receipt    TABLE     #  CREATE TABLE public.t_retur_receipt (
    id integer NOT NULL,
    no_retur character varying(10) DEFAULT lpad((nextval('public.retur_receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE NOT NULL,
    id_supplier integer NOT NULL,
    keterangan text
);
 #   DROP TABLE public.t_retur_receipt;
       public         heap    postgres    false    230            �            1259    16600    t_retur_receipt_detail    TABLE     �   CREATE TABLE public.t_retur_receipt_detail (
    id integer NOT NULL,
    id_retur_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_retur_receipt_detail;
       public         heap    postgres    false            �            1259    16603    t_retur_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_retur_receipt_detail_id_seq;
       public          postgres    false    235            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_retur_receipt_detail_id_seq OWNED BY public.t_retur_receipt_detail.id;
          public          postgres    false    236            �            1259    16604    t_retur_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_retur_receipt_id_seq;
       public          postgres    false    234            �           0    0    t_retur_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_retur_receipt_id_seq OWNED BY public.t_retur_receipt.id;
          public          postgres    false    237            �            1259    16605    t_retur_sales    TABLE     �   CREATE TABLE public.t_retur_sales (
    id integer NOT NULL,
    no_retur text DEFAULT lpad((nextval('public.retur_sales_sequence'::regclass))::text, 5, '0'::text),
    tanggal date NOT NULL,
    id_customer integer,
    keterangan text
);
 !   DROP TABLE public.t_retur_sales;
       public         heap    postgres    false    231            �            1259    16611    t_retur_sales_detail    TABLE     �   CREATE TABLE public.t_retur_sales_detail (
    id integer NOT NULL,
    id_retur_sales integer,
    id_item integer,
    qty integer NOT NULL
);
 (   DROP TABLE public.t_retur_sales_detail;
       public         heap    postgres    false            �            1259    16614    t_retur_sales_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.t_retur_sales_detail_id_seq;
       public          postgres    false    239            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.t_retur_sales_detail_id_seq OWNED BY public.t_retur_sales_detail.id;
          public          postgres    false    240            �            1259    16615    t_retur_sales_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.t_retur_sales_id_seq;
       public          postgres    false    238            �           0    0    t_retur_sales_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.t_retur_sales_id_seq OWNED BY public.t_retur_sales.id;
          public          postgres    false    241            �            1259    16616    t_trans_receipt    TABLE       CREATE TABLE public.t_trans_receipt (
    id integer NOT NULL,
    no_receipt character varying(5) DEFAULT lpad((nextval('public.receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE,
    keterangan character varying(225),
    id_supplier integer
);
 #   DROP TABLE public.t_trans_receipt;
       public         heap    postgres    false    229            �            1259    16621    t_trans_receipt_detail    TABLE     �   CREATE TABLE public.t_trans_receipt_detail (
    id integer NOT NULL,
    id_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_trans_receipt_detail;
       public         heap    postgres    false            �            1259    16624    t_trans_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_trans_receipt_detail_id_seq;
       public          postgres    false    243            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_trans_receipt_detail_id_seq OWNED BY public.t_trans_receipt_detail.id;
          public          postgres    false    244            �            1259    16625    t_trans_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_trans_receipt_id_seq;
       public          postgres    false    242            �           0    0    t_trans_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_trans_receipt_id_seq OWNED BY public.t_trans_receipt.id;
          public          postgres    false    245            �            1259    16626    t_transaksi    TABLE     !  CREATE TABLE public.t_transaksi (
    id integer NOT NULL,
    no_faktur character varying(5) DEFAULT lpad((nextval('public.faktur_sequence'::regclass))::text, 5, '0'::text) NOT NULL,
    tanggal date DEFAULT CURRENT_DATE,
    id_customer integer,
    keterangan character varying(255)
);
    DROP TABLE public.t_transaksi;
       public         heap    postgres    false    215            �            1259    16631    t_transaksi_detail    TABLE     �   CREATE TABLE public.t_transaksi_detail (
    id integer NOT NULL,
    no_faktur integer,
    id_barang integer,
    qty integer,
    harga numeric(12,2),
    subtotal numeric(12,2),
    modal numeric(12,2)
);
 &   DROP TABLE public.t_transaksi_detail;
       public         heap    postgres    false            �            1259    16634    t_transaksi_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.t_transaksi_detail_id_seq;
       public          postgres    false    247            �           0    0    t_transaksi_detail_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.t_transaksi_detail_id_seq OWNED BY public.t_transaksi_detail.id;
          public          postgres    false    248            �            1259    16635    t_transaksi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.t_transaksi_id_seq;
       public          postgres    false    246            �           0    0    t_transaksi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.t_transaksi_id_seq OWNED BY public.t_transaksi.id;
          public          postgres    false    249            �            1259    16636    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public          postgres    false    228            �           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public.m_user.id;
          public          postgres    false    250            �           2604    16637    m_customer id    DEFAULT     n   ALTER TABLE ONLY public.m_customer ALTER COLUMN id SET DEFAULT nextval('public.m_customer_id_seq'::regclass);
 <   ALTER TABLE public.m_customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            �           2604    16638 	   m_item id    DEFAULT     f   ALTER TABLE ONLY public.m_item ALTER COLUMN id SET DEFAULT nextval('public.m_item_id_seq'::regclass);
 8   ALTER TABLE public.m_item ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    16639    m_supplier id    DEFAULT     n   ALTER TABLE ONLY public.m_supplier ALTER COLUMN id SET DEFAULT nextval('public.m_supplier_id_seq'::regclass);
 <   ALTER TABLE public.m_supplier ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            �           2604    16640 	   m_user id    DEFAULT     d   ALTER TABLE ONLY public.m_user ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public.m_user ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    250    228            �           2604    16641    role id    DEFAULT     b   ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);
 6   ALTER TABLE public.role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            �           2604    16642    t_retur_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_retur_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_retur_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    234            �           2604    16643    t_retur_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_retur_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            �           2604    16644    t_retur_sales id    DEFAULT     t   ALTER TABLE ONLY public.t_retur_sales ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_id_seq'::regclass);
 ?   ALTER TABLE public.t_retur_sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    238            �           2604    16645    t_retur_sales_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_sales_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_detail_id_seq'::regclass);
 F   ALTER TABLE public.t_retur_sales_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    240    239            �           2604    16646    t_trans_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_trans_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_trans_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    242            �           2604    16647    t_trans_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_trans_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_trans_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    244    243            �           2604    16648    t_transaksi id    DEFAULT     p   ALTER TABLE ONLY public.t_transaksi ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_id_seq'::regclass);
 =   ALTER TABLE public.t_transaksi ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    246            �           2604    16649    t_transaksi_detail id    DEFAULT     ~   ALTER TABLE ONLY public.t_transaksi_detail ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_detail_id_seq'::regclass);
 D   ALTER TABLE public.t_transaksi_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    248    247            {          0    16547 
   m_customer 
   TABLE DATA           J   COPY public.m_customer (id, kode, nama, nopol, alamat, no_hp) FROM stdin;
    public          postgres    false    217   ƨ       }          0    16554    m_item 
   TABLE DATA           c   COPY public.m_item (id, kode, nama, id_satuan, id_jenis_item, stok, hpp, aktif, modal) FROM stdin;
    public          postgres    false    219   ��       �          0    16563    m_jenis_item 
   TABLE DATA           6   COPY public.m_jenis_item (id, kode, nama) FROM stdin;
    public          postgres    false    222   �       �          0    16568    m_satuan 
   TABLE DATA           ,   COPY public.m_satuan (id, nama) FROM stdin;
    public          postgres    false    224   ]�       �          0    16572 
   m_supplier 
   TABLE DATA           J   COPY public.m_supplier (id, kode, nama, no_hp, alamat, email) FROM stdin;
    public          postgres    false    225   ��       �          0    16579    m_user 
   TABLE DATA           J   COPY public.m_user (id, pegawai, username, password, id_role) FROM stdin;
    public          postgres    false    228   ��       �          0    16587    role 
   TABLE DATA           .   COPY public.role (id, kode, nama) FROM stdin;
    public          postgres    false    232   ά       �          0    16593    t_retur_receipt 
   TABLE DATA           Y   COPY public.t_retur_receipt (id, no_retur, tanggal, id_supplier, keterangan) FROM stdin;
    public          postgres    false    234   �       �          0    16600    t_retur_receipt_detail 
   TABLE DATA           T   COPY public.t_retur_receipt_detail (id, id_retur_receipt, id_item, qty) FROM stdin;
    public          postgres    false    235   խ       �          0    16605    t_retur_sales 
   TABLE DATA           W   COPY public.t_retur_sales (id, no_retur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    238   1�       �          0    16611    t_retur_sales_detail 
   TABLE DATA           P   COPY public.t_retur_sales_detail (id, id_retur_sales, id_item, qty) FROM stdin;
    public          postgres    false    239   ʮ       �          0    16616    t_trans_receipt 
   TABLE DATA           [   COPY public.t_trans_receipt (id, no_receipt, tanggal, keterangan, id_supplier) FROM stdin;
    public          postgres    false    242   "�       �          0    16621    t_trans_receipt_detail 
   TABLE DATA           N   COPY public.t_trans_receipt_detail (id, id_receipt, id_item, qty) FROM stdin;
    public          postgres    false    243   ��       �          0    16626    t_transaksi 
   TABLE DATA           V   COPY public.t_transaksi (id, no_faktur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    246   ��       �          0    16631    t_transaksi_detail 
   TABLE DATA           c   COPY public.t_transaksi_detail (id, no_faktur, id_barang, qty, harga, subtotal, modal) FROM stdin;
    public          postgres    false    247   W�       �           0    0    faktur_sequence    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.faktur_sequence', 244, true);
          public          postgres    false    215            �           0    0    kode_sequence    SEQUENCE SET     <   SELECT pg_catalog.setval('public.kode_sequence', 11, true);
          public          postgres    false    216            �           0    0    m_customer_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_customer_id_seq', 12, true);
          public          postgres    false    218            �           0    0    m_item_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.m_item_id_seq', 51, true);
          public          postgres    false    220            �           0    0    m_jenis_item_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_jenis_item_id_seq', 50, true);
          public          postgres    false    221            �           0    0    m_satuan_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_satuan_id_seq', 14, true);
          public          postgres    false    223            �           0    0    m_supplier_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_supplier_id_seq', 38, true);
          public          postgres    false    226            �           0    0    m_supplier_kode_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_supplier_kode_seq', 11, true);
          public          postgres    false    227            �           0    0    receipt_sequence    SEQUENCE SET     @   SELECT pg_catalog.setval('public.receipt_sequence', 129, true);
          public          postgres    false    229            �           0    0    retur_receipt_sequence    SEQUENCE SET     E   SELECT pg_catalog.setval('public.retur_receipt_sequence', 13, true);
          public          postgres    false    230            �           0    0    retur_sales_sequence    SEQUENCE SET     B   SELECT pg_catalog.setval('public.retur_sales_sequence', 5, true);
          public          postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 5, true);
          public          postgres    false    233            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.t_retur_receipt_detail_id_seq', 11, true);
          public          postgres    false    236            �           0    0    t_retur_receipt_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.t_retur_receipt_id_seq', 13, true);
          public          postgres    false    237            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.t_retur_sales_detail_id_seq', 10, true);
          public          postgres    false    240            �           0    0    t_retur_sales_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.t_retur_sales_id_seq', 5, true);
          public          postgres    false    241            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.t_trans_receipt_detail_id_seq', 162, true);
          public          postgres    false    244            �           0    0    t_trans_receipt_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.t_trans_receipt_id_seq', 129, true);
          public          postgres    false    245            �           0    0    t_transaksi_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.t_transaksi_detail_id_seq', 64, true);
          public          postgres    false    248            �           0    0    t_transaksi_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.t_transaksi_id_seq', 52, true);
          public          postgres    false    249            �           0    0    user_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.user_id_seq', 19, true);
          public          postgres    false    250            �           2606    16651    m_customer m_customer_kode_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_kode_key UNIQUE (kode);
 H   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_kode_key;
       public            postgres    false    217            �           2606    16653    m_customer m_customer_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_pkey;
       public            postgres    false    217            �           2606    16655    m_item m_item_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_pkey;
       public            postgres    false    219            �           2606    16657    m_jenis_item m_jenis_item_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.m_jenis_item
    ADD CONSTRAINT m_jenis_item_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.m_jenis_item DROP CONSTRAINT m_jenis_item_pkey;
       public            postgres    false    222            �           2606    16659    m_satuan m_satuan_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.m_satuan
    ADD CONSTRAINT m_satuan_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.m_satuan DROP CONSTRAINT m_satuan_pkey;
       public            postgres    false    224            �           2606    16661    m_supplier m_supplier_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_supplier
    ADD CONSTRAINT m_supplier_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_supplier DROP CONSTRAINT m_supplier_pkey;
       public            postgres    false    225            �           2606    16663    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    232            �           2606    16665 2   t_retur_receipt_detail t_retur_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT t_retur_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT t_retur_receipt_detail_pkey;
       public            postgres    false    235            �           2606    16667 $   t_retur_receipt t_retur_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT t_retur_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT t_retur_receipt_pkey;
       public            postgres    false    234            �           2606    16669 .   t_retur_sales_detail t_retur_sales_detail_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_pkey;
       public            postgres    false    239            �           2606    16671     t_retur_sales t_retur_sales_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_pkey;
       public            postgres    false    238            �           2606    16673 2   t_trans_receipt_detail t_trans_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_pkey;
       public            postgres    false    243            �           2606    16675 $   t_trans_receipt t_trans_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT t_trans_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT t_trans_receipt_pkey;
       public            postgres    false    242            �           2606    16677 *   t_transaksi_detail t_transaksi_detail_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_pkey;
       public            postgres    false    247            �           2606    16679    t_transaksi t_transaksi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_pkey;
       public            postgres    false    246            �           2606    16681 &   t_retur_sales_detail unique_retur_item 
   CONSTRAINT     t   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT unique_retur_item UNIQUE (id_retur_sales, id_item);
 P   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT unique_retur_item;
       public            postgres    false    239    239            �           2606    16683    m_user unique_username 
   CONSTRAINT     U   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT unique_username UNIQUE (username);
 @   ALTER TABLE ONLY public.m_user DROP CONSTRAINT unique_username;
       public            postgres    false    228            �           2606    16685    m_user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_pkey;
       public            postgres    false    228            �           2620    16686 &   m_supplier set_default_m_supplier_kode    TRIGGER     �   CREATE TRIGGER set_default_m_supplier_kode BEFORE INSERT ON public.m_supplier FOR EACH ROW EXECUTE FUNCTION public.set_default_m_supplier_kode();
 ?   DROP TRIGGER set_default_m_supplier_kode ON public.m_supplier;
       public          postgres    false    225    253            �           2620    16687     m_customer trigger_generate_kode    TRIGGER     �   CREATE TRIGGER trigger_generate_kode BEFORE INSERT ON public.m_customer FOR EACH ROW WHEN ((new.kode IS NULL)) EXECUTE FUNCTION public.generate_kode();
 9   DROP TRIGGER trigger_generate_kode ON public.m_customer;
       public          postgres    false    251    217    217            �           2606    16688    t_trans_receipt fk_id_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT fk_id_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id);
 H   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT fk_id_supplier;
       public          postgres    false    3264    242    225            �           2606    16693    t_retur_receipt_detail fk_item    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_item FOREIGN KEY (id_item) REFERENCES public.m_item(id) ON DELETE RESTRICT;
 H   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_item;
       public          postgres    false    3258    235    219            �           2606    16698 '   t_retur_receipt_detail fk_retur_receipt    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_retur_receipt FOREIGN KEY (id_retur_receipt) REFERENCES public.t_retur_receipt(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_retur_receipt;
       public          postgres    false    3272    235    234            �           2606    16703    t_retur_receipt fk_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT fk_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id) ON DELETE RESTRICT;
 E   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT fk_supplier;
       public          postgres    false    3264    225    234            �           2606    16708     m_item m_item_id_jenis_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_jenis_item_fkey FOREIGN KEY (id_jenis_item) REFERENCES public.m_jenis_item(id);
 J   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_jenis_item_fkey;
       public          postgres    false    3260    219    222            �           2606    16713    m_item m_item_id_satuan_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_satuan_fkey FOREIGN KEY (id_satuan) REFERENCES public.m_satuan(id);
 F   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_satuan_fkey;
       public          postgres    false    3262    219    224            �           2606    16718 6   t_retur_sales_detail t_retur_sales_detail_id_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_item_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 `   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_item_fkey;
       public          postgres    false    219    3258    239            �           2606    16723 =   t_retur_sales_detail t_retur_sales_detail_id_retur_sales_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey FOREIGN KEY (id_retur_sales) REFERENCES public.t_retur_sales(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey;
       public          postgres    false    238    3276    239            �           2606    16728 ,   t_retur_sales t_retur_sales_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 V   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_id_customer_fkey;
       public          postgres    false    217    3256    238            �           2606    16733 ;   t_trans_receipt_detail t_trans_receipt_detail_id_items_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_items_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 e   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_items_fkey;
       public          postgres    false    219    243    3258            �           2606    16738 =   t_trans_receipt_detail t_trans_receipt_detail_id_receipt_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_receipt_fkey FOREIGN KEY (id_receipt) REFERENCES public.t_trans_receipt(id);
 g   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_receipt_fkey;
       public          postgres    false    243    3282    242            �           2606    16743 4   t_transaksi_detail t_transaksi_detail_id_barang_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_id_barang_fkey FOREIGN KEY (id_barang) REFERENCES public.m_item(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_id_barang_fkey;
       public          postgres    false    3258    247    219            �           2606    16748 4   t_transaksi_detail t_transaksi_detail_no_faktur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_no_faktur_fkey FOREIGN KEY (no_faktur) REFERENCES public.t_transaksi(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_no_faktur_fkey;
       public          postgres    false    246    3286    247            �           2606    16753 (   t_transaksi t_transaksi_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 R   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_id_customer_fkey;
       public          postgres    false    217    246    3256            �           2606    16758    m_user user_id_role_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id);
 B   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_id_role_fkey;
       public          postgres    false    3270    228    232            {   �   x�M�M�� �9'a~,�	mP� ���?G�fӍ7�{ֳ��2@�A��/:�Xs���A��^oTAq� �T�Fr�fzrV�G|�1ީu�g˲�Fz�,㭎!�X���۽���[	��6�->D���+A���=�t&^$r�5���DN�ϕjJT�S�==ƙ��)Vk��x�!>i/7�      }   o  x�u�Mn�0���>Ad���)N�b "P�R����f�NAUX��o��޳�Lj%d���Gޥ7��!��?�CT*}5FH`w���wnBX3)a�%r����?4��ds�cnb���LZ(m,r~�%�G�e���/����)����,a�7ҡX�V���A��9�Ū�F��(^Y*�Y�=���]�!>2��l3Yc˔$��|���O�;��S����%����+�?C$"0��-[����6{�<(��~�Ǣ�Tk���2��=�&Ҭ18�=��������p��|���1�U�:UI����&޻d��>�s�QŰ�v��3�,��'�$��N-̿��2�Ӂ@�ߗ��~N��W      �   <   x�31�445506��Upvtq�s�21���p��y+ E\}#���b���� p��      �      x�34�p�����       �   �   x�m�An� E���@� �$��1!$20��z�s��h*u�=[�BJ9�3��كō��τ���C��q��J\�����L�`�"H��l��/���{s�W| CGt�?���͝%`�ɑ7TN0�м��Ck���vN�3���E�!!��5�..5�xګ��� ;x5@>� �:G�-��<����x@�>�[�=;C6��� �-�Vݻ`���ڑ�R�rN�¦^�'BS񟿺�˺�m�4_'�b+      �   4   x�3�t�t�Spr�U�LL��̃��\������A��ũE+F��� ��      �   9   x�3�tt����tL����,.)J,�/�2�v�H�KO/�KTp�L,N����� u��      �   �   x����
�0�띧8/`lg��r�+ﺙ$!��̞�9D��v`W��� ��#F�∫�'LJf��䰶��wt�h;P�&�2�l�-��_�Ŷ�G�ZH�N���5x�,>���.���N]��Tg]�����?
��:���Kep��6y��g� B��\�����\7 �2�D�      �   L   x�%��� ���0=�
�t�9?]�( �Eʴ1�ب�pP�4�Րj�/Ho�:�N��E��إt��C�F��      �   �   x�3�4 CN##]s]SNN���D��Ԓ�"��Ĝ�b���D�̼��ܼ�D.#�#d-���(d�*q��C�Y �*'�� GO���`Go.��sN3�`GG7G�� .S�
S�*��`�=... :4�      �   H   x�%��	�0Cѳ4L�-;m����(�x|�@2�%���M�Wn����uP|~4_4J.1��i]$7`K�      �   �  x�u�[j1E�ǫ�R$�I�C�ZRh
����Q����)C8��{<X�BDZ!);�ׅ���]rIZ�kϥP����5�
���T*K�K֤
�=�e�kT�j=ݎ�Ck���k2j<��e�ٿ�m߿����������Mn ���2`)|Y�@�աO �uPc:O+f��`�|�p�p�*�}L��#��\��>&����|;���^G�ɑ���10���=� �?d@v����·u�� ��3	���d�<c* ��6B�4��
Q��1���M�@O<0<075���˓�"�A����a��D�V�OD0D��1��<���!��"2-9ދ�nYb������\mخ]D�>yq�@����&�ӡ1�@L�.c
�H�����E������/0��6�uE��X�7�cA�\U��Y�V{zM)��?      �   �  x�=��u !D�c1y��b/鿎|X7�A>�gh/���,��J=M��qm�P��'%�ȭ�hv�%GʓrlY��KGi�+=꜒�Y�$-w�G{j*N4=#�9Mϧ���>�~ϭ+�Ӧ7ǆbf}j�T���-�߶��K;)�����Ď��vt����ڎ�3o�1��7	cg1��T��k������fso��t7���2���Q���Wy5�&�Xs)]��+m�e�|�>�FM6�р� �f���Z����Z0�7���+�`��,/~" ����L(����7P>�jyqހ�X�I_@A�
���D������;HX�*H��Z�S�U�ړ���� ���O; iҬQ�^Q.:#2F�G�q��ߟ���x��      �   �  x�mS���0�9_�p �u�tVX���v�4����>���ys�C����;nYmhũK�(�<��x^���>7/�ܤi��S��g��`@ʀ��Q@5<�������4�g�oԡ���G��V;�b�4 
��2iNq����'��K�`��i�+�6c��`��b�^}��d���7����jp�y����17�q5N318q�i���7���}�!�s=fud�R�{bE]�~&FZv{�mBL��.gQq_�'�8a��я��|�9��?�a[�������a8����1��H BB�_��D�m7Yl/��h06�o@�<����6��Z��H$E�ږ+r��<&���N���R� ��� RHג��{
��m�[�
���3�+)���� �:>K�v�
p |ȹ_~S��X����ϕ<�t��&6�~~#��*�Ԥ      �   �  x���[��0D��b��� ��
�s���;�Ai�*!ę8��I��$��1��
��|ދ���4����:\�����F�;�����Q��p��R�J�+�J�r09�N��i�kj�88��Li�1�s��6�oN���ufs�������ɉ��tw�Y7~�4�A4��c�y�a�7��m�5��-@U`{�d��2��̇38����\3�N8`���o��B�|RA�^g�XasŬ�
1k�U���|\��>�8�w]��c���
�����H�c(\��[ ���-æB��*P�^�I>y�F���U;�p«*b���o*&���tBn�-���RrӰ-��g�%3�l��`鮊Y�]�?2K��>xW:���s��"�fϑ��]L^"��=9�@
Y�0��	Mx��$t��םT�.I]����c{�e����*V|^˲���F�     