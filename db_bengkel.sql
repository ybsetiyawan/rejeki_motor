PGDMP      %                }         
   db_bengkel     16.4 (Ubuntu 16.4-1.pgdg20.04+1)    16.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17120 
   db_bengkel    DATABASE     r   CREATE DATABASE db_bengkel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE db_bengkel;
                postgres    false            �            1255    17121    generate_kode()    FUNCTION     �   CREATE FUNCTION public.generate_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('kode_sequence')::text, 4, '0');
	RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.generate_kode();
       public          postgres    false            �            1255    17122    set_default_kode()    FUNCTION       CREATE FUNCTION public.set_default_kode() RETURNS trigger
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
       public          postgres    false            �            1255    17123    set_default_m_supplier_kode()    FUNCTION     �   CREATE FUNCTION public.set_default_m_supplier_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('m_supplier_kode_seq'::regclass)::text, 4, '1');
    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.set_default_m_supplier_kode();
       public          postgres    false            �            1259    17124    faktur_sequence    SEQUENCE     x   CREATE SEQUENCE public.faktur_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.faktur_sequence;
       public          postgres    false            �            1259    17125    kode_sequence    SEQUENCE     v   CREATE SEQUENCE public.kode_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.kode_sequence;
       public          postgres    false            �            1259    17126 
   m_customer    TABLE     &  CREATE TABLE public.m_customer (
    id integer NOT NULL,
    kode character varying(4) DEFAULT lpad((nextval('public.kode_sequence'::regclass))::text, 4, '0'::text),
    nama character varying(100) NOT NULL,
    nopol character varying(20),
    alamat text,
    no_hp character varying(15)
);
    DROP TABLE public.m_customer;
       public         heap    postgres    false    216            �            1259    17132    m_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_customer_id_seq;
       public          postgres    false    217            �           0    0    m_customer_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_customer_id_seq OWNED BY public.m_customer.id;
          public          postgres    false    218            �            1259    17133    m_item    TABLE       CREATE TABLE public.m_item (
    id integer NOT NULL,
    kode character varying(50),
    nama character varying(255),
    id_satuan integer,
    id_jenis_item integer,
    stok integer DEFAULT 0,
    hpp integer,
    aktif boolean DEFAULT true,
    modal integer
);
    DROP TABLE public.m_item;
       public         heap    postgres    false            �            1259    17140    m_item_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.m_item_id_seq;
       public          postgres    false    219            �           0    0    m_item_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.m_item_id_seq OWNED BY public.m_item.id;
          public          postgres    false    220            �            1259    17141    m_jenis_item_id_seq    SEQUENCE     |   CREATE SEQUENCE public.m_jenis_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.m_jenis_item_id_seq;
       public          postgres    false            �            1259    17142    m_jenis_item    TABLE     �   CREATE TABLE public.m_jenis_item (
    id integer DEFAULT nextval('public.m_jenis_item_id_seq'::regclass) NOT NULL,
    kode character varying(20),
    nama character varying(100)
);
     DROP TABLE public.m_jenis_item;
       public         heap    postgres    false    221            �            1259    17146    m_satuan_id_seq    SEQUENCE     x   CREATE SEQUENCE public.m_satuan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.m_satuan_id_seq;
       public          postgres    false            �            1259    17147    m_satuan    TABLE     �   CREATE TABLE public.m_satuan (
    id integer DEFAULT nextval('public.m_satuan_id_seq'::regclass) NOT NULL,
    nama character varying(50)
);
    DROP TABLE public.m_satuan;
       public         heap    postgres    false    223            �            1259    17151 
   m_supplier    TABLE     �   CREATE TABLE public.m_supplier (
    id integer NOT NULL,
    kode character varying(4),
    nama character varying(50) NOT NULL,
    no_hp character varying(20),
    alamat text,
    email character varying(30)
);
    DROP TABLE public.m_supplier;
       public         heap    postgres    false            �            1259    17156    m_supplier_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_supplier_id_seq;
       public          postgres    false    225            �           0    0    m_supplier_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_supplier_id_seq OWNED BY public.m_supplier.id;
          public          postgres    false    226            �            1259    17157    m_supplier_kode_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_kode_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1
    CYCLE;
 *   DROP SEQUENCE public.m_supplier_kode_seq;
       public          postgres    false            �            1259    17158    m_user    TABLE     �   CREATE TABLE public.m_user (
    id integer NOT NULL,
    pegawai character varying NOT NULL,
    username character varying NOT NULL,
    password text,
    id_role integer
);
    DROP TABLE public.m_user;
       public         heap    postgres    false            �            1259    17163    receipt_sequence    SEQUENCE     y   CREATE SEQUENCE public.receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.receipt_sequence;
       public          postgres    false            �            1259    17164    retur_receipt_sequence    SEQUENCE     �   CREATE SEQUENCE public.retur_receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;
 -   DROP SEQUENCE public.retur_receipt_sequence;
       public          postgres    false            �            1259    17165    retur_sales_sequence    SEQUENCE     }   CREATE SEQUENCE public.retur_sales_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.retur_sales_sequence;
       public          postgres    false            �            1259    17166    role    TABLE     n   CREATE TABLE public.role (
    id integer NOT NULL,
    kode character varying,
    nama character varying
);
    DROP TABLE public.role;
       public         heap    postgres    false            �            1259    17171    role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.role_id_seq;
       public          postgres    false    232            �           0    0    role_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;
          public          postgres    false    233            �            1259    17172    t_retur_receipt    TABLE     #  CREATE TABLE public.t_retur_receipt (
    id integer NOT NULL,
    no_retur character varying(10) DEFAULT lpad((nextval('public.retur_receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE NOT NULL,
    id_supplier integer NOT NULL,
    keterangan text
);
 #   DROP TABLE public.t_retur_receipt;
       public         heap    postgres    false    230            �            1259    17179    t_retur_receipt_detail    TABLE     �   CREATE TABLE public.t_retur_receipt_detail (
    id integer NOT NULL,
    id_retur_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_retur_receipt_detail;
       public         heap    postgres    false            �            1259    17182    t_retur_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_retur_receipt_detail_id_seq;
       public          postgres    false    235            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_retur_receipt_detail_id_seq OWNED BY public.t_retur_receipt_detail.id;
          public          postgres    false    236            �            1259    17183    t_retur_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_retur_receipt_id_seq;
       public          postgres    false    234            �           0    0    t_retur_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_retur_receipt_id_seq OWNED BY public.t_retur_receipt.id;
          public          postgres    false    237            �            1259    17184    t_retur_sales    TABLE     �   CREATE TABLE public.t_retur_sales (
    id integer NOT NULL,
    no_retur text DEFAULT lpad((nextval('public.retur_sales_sequence'::regclass))::text, 5, '0'::text),
    tanggal date NOT NULL,
    id_customer integer,
    keterangan text
);
 !   DROP TABLE public.t_retur_sales;
       public         heap    postgres    false    231            �            1259    17190    t_retur_sales_detail    TABLE     �   CREATE TABLE public.t_retur_sales_detail (
    id integer NOT NULL,
    id_retur_sales integer,
    id_item integer,
    qty integer NOT NULL
);
 (   DROP TABLE public.t_retur_sales_detail;
       public         heap    postgres    false            �            1259    17193    t_retur_sales_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.t_retur_sales_detail_id_seq;
       public          postgres    false    239            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.t_retur_sales_detail_id_seq OWNED BY public.t_retur_sales_detail.id;
          public          postgres    false    240            �            1259    17194    t_retur_sales_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.t_retur_sales_id_seq;
       public          postgres    false    238            �           0    0    t_retur_sales_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.t_retur_sales_id_seq OWNED BY public.t_retur_sales.id;
          public          postgres    false    241            �            1259    17195    t_trans_receipt    TABLE       CREATE TABLE public.t_trans_receipt (
    id integer NOT NULL,
    no_receipt character varying(5) DEFAULT lpad((nextval('public.receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE,
    keterangan character varying(225),
    id_supplier integer
);
 #   DROP TABLE public.t_trans_receipt;
       public         heap    postgres    false    229            �            1259    17200    t_trans_receipt_detail    TABLE     �   CREATE TABLE public.t_trans_receipt_detail (
    id integer NOT NULL,
    id_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_trans_receipt_detail;
       public         heap    postgres    false            �            1259    17203    t_trans_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_trans_receipt_detail_id_seq;
       public          postgres    false    243            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_trans_receipt_detail_id_seq OWNED BY public.t_trans_receipt_detail.id;
          public          postgres    false    244            �            1259    17204    t_trans_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_trans_receipt_id_seq;
       public          postgres    false    242            �           0    0    t_trans_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_trans_receipt_id_seq OWNED BY public.t_trans_receipt.id;
          public          postgres    false    245            �            1259    17205    t_transaksi    TABLE     !  CREATE TABLE public.t_transaksi (
    id integer NOT NULL,
    no_faktur character varying(5) DEFAULT lpad((nextval('public.faktur_sequence'::regclass))::text, 5, '0'::text) NOT NULL,
    tanggal date DEFAULT CURRENT_DATE,
    id_customer integer,
    keterangan character varying(255)
);
    DROP TABLE public.t_transaksi;
       public         heap    postgres    false    215            �            1259    17210    t_transaksi_detail    TABLE     �   CREATE TABLE public.t_transaksi_detail (
    id integer NOT NULL,
    no_faktur integer,
    id_barang integer,
    qty integer,
    harga numeric(12,2),
    subtotal numeric(12,2),
    modal numeric(12,2)
);
 &   DROP TABLE public.t_transaksi_detail;
       public         heap    postgres    false            �            1259    17213    t_transaksi_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.t_transaksi_detail_id_seq;
       public          postgres    false    247            �           0    0    t_transaksi_detail_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.t_transaksi_detail_id_seq OWNED BY public.t_transaksi_detail.id;
          public          postgres    false    248            �            1259    17214    t_transaksi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.t_transaksi_id_seq;
       public          postgres    false    246            �           0    0    t_transaksi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.t_transaksi_id_seq OWNED BY public.t_transaksi.id;
          public          postgres    false    249            �            1259    17215    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public          postgres    false    228            �           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public.m_user.id;
          public          postgres    false    250            �           2604    17216    m_customer id    DEFAULT     n   ALTER TABLE ONLY public.m_customer ALTER COLUMN id SET DEFAULT nextval('public.m_customer_id_seq'::regclass);
 <   ALTER TABLE public.m_customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            �           2604    17217 	   m_item id    DEFAULT     f   ALTER TABLE ONLY public.m_item ALTER COLUMN id SET DEFAULT nextval('public.m_item_id_seq'::regclass);
 8   ALTER TABLE public.m_item ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            �           2604    17218    m_supplier id    DEFAULT     n   ALTER TABLE ONLY public.m_supplier ALTER COLUMN id SET DEFAULT nextval('public.m_supplier_id_seq'::regclass);
 <   ALTER TABLE public.m_supplier ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            �           2604    17219 	   m_user id    DEFAULT     d   ALTER TABLE ONLY public.m_user ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public.m_user ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    250    228            �           2604    17220    role id    DEFAULT     b   ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);
 6   ALTER TABLE public.role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            �           2604    17221    t_retur_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_retur_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_retur_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    234            �           2604    17222    t_retur_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_retur_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            �           2604    17223    t_retur_sales id    DEFAULT     t   ALTER TABLE ONLY public.t_retur_sales ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_id_seq'::regclass);
 ?   ALTER TABLE public.t_retur_sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    238            �           2604    17224    t_retur_sales_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_sales_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_detail_id_seq'::regclass);
 F   ALTER TABLE public.t_retur_sales_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    240    239            �           2604    17225    t_trans_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_trans_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_trans_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    242            �           2604    17226    t_trans_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_trans_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_trans_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    244    243            �           2604    17227    t_transaksi id    DEFAULT     p   ALTER TABLE ONLY public.t_transaksi ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_id_seq'::regclass);
 =   ALTER TABLE public.t_transaksi ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    246            �           2604    17228    t_transaksi_detail id    DEFAULT     ~   ALTER TABLE ONLY public.t_transaksi_detail ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_detail_id_seq'::regclass);
 D   ALTER TABLE public.t_transaksi_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    248    247            {          0    17126 
   m_customer 
   TABLE DATA           J   COPY public.m_customer (id, kode, nama, nopol, alamat, no_hp) FROM stdin;
    public          postgres    false    217   ��       }          0    17133    m_item 
   TABLE DATA           c   COPY public.m_item (id, kode, nama, id_satuan, id_jenis_item, stok, hpp, aktif, modal) FROM stdin;
    public          postgres    false    219   &�       �          0    17142    m_jenis_item 
   TABLE DATA           6   COPY public.m_jenis_item (id, kode, nama) FROM stdin;
    public          postgres    false    222   �M      �          0    17147    m_satuan 
   TABLE DATA           ,   COPY public.m_satuan (id, nama) FROM stdin;
    public          postgres    false    224   �R      �          0    17151 
   m_supplier 
   TABLE DATA           J   COPY public.m_supplier (id, kode, nama, no_hp, alamat, email) FROM stdin;
    public          postgres    false    225   S      �          0    17158    m_user 
   TABLE DATA           J   COPY public.m_user (id, pegawai, username, password, id_role) FROM stdin;
    public          postgres    false    228   lV      �          0    17166    role 
   TABLE DATA           .   COPY public.role (id, kode, nama) FROM stdin;
    public          postgres    false    232   &W      �          0    17172    t_retur_receipt 
   TABLE DATA           Y   COPY public.t_retur_receipt (id, no_retur, tanggal, id_supplier, keterangan) FROM stdin;
    public          postgres    false    234   oW      �          0    17179    t_retur_receipt_detail 
   TABLE DATA           T   COPY public.t_retur_receipt_detail (id, id_retur_receipt, id_item, qty) FROM stdin;
    public          postgres    false    235   `X      �          0    17184    t_retur_sales 
   TABLE DATA           W   COPY public.t_retur_sales (id, no_retur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    238   �X      �          0    17190    t_retur_sales_detail 
   TABLE DATA           P   COPY public.t_retur_sales_detail (id, id_retur_sales, id_item, qty) FROM stdin;
    public          postgres    false    239   Y      �          0    17195    t_trans_receipt 
   TABLE DATA           [   COPY public.t_trans_receipt (id, no_receipt, tanggal, keterangan, id_supplier) FROM stdin;
    public          postgres    false    242   "Y      �          0    17200    t_trans_receipt_detail 
   TABLE DATA           N   COPY public.t_trans_receipt_detail (id, id_receipt, id_item, qty) FROM stdin;
    public          postgres    false    243   �a      �          0    17205    t_transaksi 
   TABLE DATA           V   COPY public.t_transaksi (id, no_faktur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    246   (q      �          0    17210    t_transaksi_detail 
   TABLE DATA           c   COPY public.t_transaksi_detail (id, no_faktur, id_barang, qty, harga, subtotal, modal) FROM stdin;
    public          postgres    false    247   �t      �           0    0    faktur_sequence    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.faktur_sequence', 139, true);
          public          postgres    false    215            �           0    0    kode_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.kode_sequence', 2, true);
          public          postgres    false    216            �           0    0    m_customer_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.m_customer_id_seq', 2, true);
          public          postgres    false    218            �           0    0    m_item_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_item_id_seq', 4529, true);
          public          postgres    false    220            �           0    0    m_jenis_item_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.m_jenis_item_id_seq', 163, true);
          public          postgres    false    221            �           0    0    m_satuan_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.m_satuan_id_seq', 2, true);
          public          postgres    false    223            �           0    0    m_supplier_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_supplier_id_seq', 25, true);
          public          postgres    false    226            �           0    0    m_supplier_kode_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_supplier_kode_seq', 25, true);
          public          postgres    false    227            �           0    0    receipt_sequence    SEQUENCE SET     @   SELECT pg_catalog.setval('public.receipt_sequence', 250, true);
          public          postgres    false    229            �           0    0    retur_receipt_sequence    SEQUENCE SET     E   SELECT pg_catalog.setval('public.retur_receipt_sequence', 13, true);
          public          postgres    false    230            �           0    0    retur_sales_sequence    SEQUENCE SET     B   SELECT pg_catalog.setval('public.retur_sales_sequence', 1, true);
          public          postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 3, true);
          public          postgres    false    233            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.t_retur_receipt_detail_id_seq', 18, true);
          public          postgres    false    236            �           0    0    t_retur_receipt_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.t_retur_receipt_id_seq', 13, true);
          public          postgres    false    237            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.t_retur_sales_detail_id_seq', 1, true);
          public          postgres    false    240            �           0    0    t_retur_sales_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.t_retur_sales_id_seq', 1, true);
          public          postgres    false    241            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.t_trans_receipt_detail_id_seq', 706, true);
          public          postgres    false    244            �           0    0    t_trans_receipt_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.t_trans_receipt_id_seq', 250, true);
          public          postgres    false    245            �           0    0    t_transaksi_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.t_transaksi_detail_id_seq', 5349, true);
          public          postgres    false    248            �           0    0    t_transaksi_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.t_transaksi_id_seq', 137, true);
          public          postgres    false    249            �           0    0    user_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.user_id_seq', 5, true);
          public          postgres    false    250            �           2606    17230    m_customer m_customer_kode_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_kode_key UNIQUE (kode);
 H   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_kode_key;
       public            postgres    false    217            �           2606    17232    m_customer m_customer_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_pkey;
       public            postgres    false    217            �           2606    17234    m_item m_item_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_pkey;
       public            postgres    false    219            �           2606    17236    m_jenis_item m_jenis_item_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.m_jenis_item
    ADD CONSTRAINT m_jenis_item_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.m_jenis_item DROP CONSTRAINT m_jenis_item_pkey;
       public            postgres    false    222            �           2606    17238    m_satuan m_satuan_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.m_satuan
    ADD CONSTRAINT m_satuan_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.m_satuan DROP CONSTRAINT m_satuan_pkey;
       public            postgres    false    224            �           2606    17240    m_supplier m_supplier_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_supplier
    ADD CONSTRAINT m_supplier_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_supplier DROP CONSTRAINT m_supplier_pkey;
       public            postgres    false    225            �           2606    17242    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    232            �           2606    17244 2   t_retur_receipt_detail t_retur_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT t_retur_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT t_retur_receipt_detail_pkey;
       public            postgres    false    235            �           2606    17246 $   t_retur_receipt t_retur_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT t_retur_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT t_retur_receipt_pkey;
       public            postgres    false    234            �           2606    17248 .   t_retur_sales_detail t_retur_sales_detail_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_pkey;
       public            postgres    false    239            �           2606    17250     t_retur_sales t_retur_sales_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_pkey;
       public            postgres    false    238            �           2606    17252 2   t_trans_receipt_detail t_trans_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_pkey;
       public            postgres    false    243            �           2606    17254 $   t_trans_receipt t_trans_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT t_trans_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT t_trans_receipt_pkey;
       public            postgres    false    242            �           2606    17256 *   t_transaksi_detail t_transaksi_detail_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_pkey;
       public            postgres    false    247            �           2606    17258    t_transaksi t_transaksi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_pkey;
       public            postgres    false    246            �           2606    17260 &   t_retur_sales_detail unique_retur_item 
   CONSTRAINT     t   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT unique_retur_item UNIQUE (id_retur_sales, id_item);
 P   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT unique_retur_item;
       public            postgres    false    239    239            �           2606    17262    m_user unique_username 
   CONSTRAINT     U   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT unique_username UNIQUE (username);
 @   ALTER TABLE ONLY public.m_user DROP CONSTRAINT unique_username;
       public            postgres    false    228            �           2606    17264    m_user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_pkey;
       public            postgres    false    228            �           2620    17265 &   m_supplier set_default_m_supplier_kode    TRIGGER     �   CREATE TRIGGER set_default_m_supplier_kode BEFORE INSERT ON public.m_supplier FOR EACH ROW EXECUTE FUNCTION public.set_default_m_supplier_kode();
 ?   DROP TRIGGER set_default_m_supplier_kode ON public.m_supplier;
       public          postgres    false    225    253            �           2620    17266     m_customer trigger_generate_kode    TRIGGER     �   CREATE TRIGGER trigger_generate_kode BEFORE INSERT ON public.m_customer FOR EACH ROW WHEN ((new.kode IS NULL)) EXECUTE FUNCTION public.generate_kode();
 9   DROP TRIGGER trigger_generate_kode ON public.m_customer;
       public          postgres    false    251    217    217            �           2606    17267    t_trans_receipt fk_id_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT fk_id_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id);
 H   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT fk_id_supplier;
       public          postgres    false    225    242    3264            �           2606    17272    t_retur_receipt_detail fk_item    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_item FOREIGN KEY (id_item) REFERENCES public.m_item(id) ON DELETE RESTRICT;
 H   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_item;
       public          postgres    false    219    3258    235            �           2606    17277 '   t_retur_receipt_detail fk_retur_receipt    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_retur_receipt FOREIGN KEY (id_retur_receipt) REFERENCES public.t_retur_receipt(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_retur_receipt;
       public          postgres    false    234    3272    235            �           2606    17282    t_retur_receipt fk_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT fk_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id) ON DELETE RESTRICT;
 E   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT fk_supplier;
       public          postgres    false    225    3264    234            �           2606    17287     m_item m_item_id_jenis_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_jenis_item_fkey FOREIGN KEY (id_jenis_item) REFERENCES public.m_jenis_item(id);
 J   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_jenis_item_fkey;
       public          postgres    false    222    3260    219            �           2606    17292    m_item m_item_id_satuan_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_satuan_fkey FOREIGN KEY (id_satuan) REFERENCES public.m_satuan(id);
 F   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_satuan_fkey;
       public          postgres    false    3262    224    219            �           2606    17297 6   t_retur_sales_detail t_retur_sales_detail_id_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_item_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 `   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_item_fkey;
       public          postgres    false    3258    239    219            �           2606    17302 =   t_retur_sales_detail t_retur_sales_detail_id_retur_sales_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey FOREIGN KEY (id_retur_sales) REFERENCES public.t_retur_sales(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey;
       public          postgres    false    3276    238    239            �           2606    17307 ,   t_retur_sales t_retur_sales_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 V   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_id_customer_fkey;
       public          postgres    false    238    3256    217            �           2606    17312 ;   t_trans_receipt_detail t_trans_receipt_detail_id_items_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_items_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 e   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_items_fkey;
       public          postgres    false    219    3258    243            �           2606    17317 =   t_trans_receipt_detail t_trans_receipt_detail_id_receipt_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_receipt_fkey FOREIGN KEY (id_receipt) REFERENCES public.t_trans_receipt(id);
 g   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_receipt_fkey;
       public          postgres    false    243    3282    242            �           2606    17322 4   t_transaksi_detail t_transaksi_detail_id_barang_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_id_barang_fkey FOREIGN KEY (id_barang) REFERENCES public.m_item(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_id_barang_fkey;
       public          postgres    false    219    247    3258            �           2606    17327 4   t_transaksi_detail t_transaksi_detail_no_faktur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_no_faktur_fkey FOREIGN KEY (no_faktur) REFERENCES public.t_transaksi(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_no_faktur_fkey;
       public          postgres    false    246    247    3286            �           2606    17332 (   t_transaksi t_transaksi_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 R   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_id_customer_fkey;
       public          postgres    false    217    246    3256            �           2606    17337    m_user user_id_role_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id);
 B   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_id_role_fkey;
       public          postgres    false    3270    232    228            {   U   x�3�4000�r�r��T���⌀ N/GG?o� G?w_W?/ ���+��Z�����i`ahdlbhhjjj����� ���      }      x����v#7-�>��
>�G/'��|[�ĒX�DRr]�����1 �L��O��]�s������b���>���緧/��2_���?_�_����?v
���_��χ�����9���w������a���BPO�f?M�R'�:���o�����ذ��?_�/���O��K �I�׀& �����������K�/����$�R6�o��.�S׾t.�/	oc���{���}j7:ӧs�����3��cX!�ש|�rxܣ靝�F!����c5vP��Sϫ��wDNg�wק����Ф�8��:[��+���^��ڎs&_t�d�K*4���t@������މ��)���ܿ>������ݿ���;�>����w��j<˔i�.��w�=#6�D��y�=�_h%���� ���s˺��'��e�;}�����ՙVǛ5��s^/�L���&`��p�険�21gZ(�֠�=�ChX BÙ~�~r����ߕݚ�/H�e��t~c�.?w��۔�q����>N�ï��v�ˑ>O�/�[0HВ���O
�d�,=�J��R�3-����� M> M �a�	�Y���Xh����%��� A@f�Y��Dk�SE�����SR$,���;x��0� ����������)���ݸ1���b�"�YfEZݐ֘����R0�d���-���v��<�*���B+���;�h�|/l�ТF3~_4ѢE���B}F7 �^ւk�Ո�<���g�{D~-�(1]������u����w��l��ڊ�b4��g�ɯD���� ��B����<5$��+�ؿv���1�*A/�C��G3@�d'�_����\������9�f�������n��9D�7�T�������N��&E�0�ͼl��y�c{���a�nw�t~:w��e�Jd6���\�UP�%��?�����If�,3�z���v,�=[*Im�
�9#�aQ�\�����Z�R��;CL������K��:r���~�)�����W뫳0c�8K?.Fሏ_�}��Uع�F��Y�B1% �H�*ҳ̆!L6�&��̺CZ�E/[^kM�X��̌m	#��Nh�H�ܑ��w�$�H��!8�K�v�@?Ί����>��>K�l��L�a����k��w����pW~}��F��L<�<0+���d0�"j��&)�%�v�n^M�b�M[�@;����݁�q�����lt)�c$�c5�׿����������o����η[�qWUv����%V�]�������ʗ�)�I�����%}|\vċ/'�*m޴զŔMZ�]�����_������l��e�z���I�����?�f8\3�9�o*���>Y�Ť�u�^:̌Z��E\4�̔��?yR��-�3áˬ�ֲ}l����"�L{�$d�x�]l]��
�r����\�OD/�~)뜍��솑�����h!��^U��6&�!S۔~�<mӠlP,���Ac۠fID.,	q&q'��8��ϗ] �9�]\: ��ޔ�sx,��v0�rT�_1z�U���'�X�v}ٽ�_��/�^$!��M5x�);T���#Μ5'�f��Ix�F�01^���{\V����%K����	���ՔB��9׷]z�����i��a���V�x�D�O���̻�/�����e<��-h��1�@�������1�`ls��\!f$�c����:�"�h�&[��aӟ{L��Yh�����p%UF.mC�2��$�g�+��D�I��I֪&��/����y7�Ɔ`�`���������K#U��+z��8]K[��@l�lSG��W�A^va֩<��������ӱ��IA��%�X#���U�9�� ]e霬A�c*¦���	��}��|� g��]]���>��`���}/��s�51���k�#Z$Y&3mArm�*O�� 9f@�-kc]��ݝ�Ok��t�YI��h7@�ϯ�xE��Ĉ�~��ޕ~���t��1��Q+���#�e��4�5�(o�ēy���w�oo����藀ωX�>�>��2��։L�U��M�k�W4
 �!
�&L]X�zo�Z�qO�JR' ���P��=+��y���ɨ%˱r�b��~})PÇL�֔��ߟ���00��a���!
d{{N��ڜ���씥 �P�(H��������xY���������D�d�S�����a��V_�~����ފ`����x���YQ;R[��^�..}�oU�D4oAu�bà�ݶ~&+���o�!e�W��E�&�=�3�l��O�< ޮ����b�ub�2��N�MP}6βefT�2�I;C(��4
廲�����I��*��7o��9Y��z7�b@D'e಩D�z3@��B�_%S1ϲ��_��-�e�a��0M���s�u�,��m�h�]H�@f��m߲XR�=�du��&!I�K]�����	)	��/+Â�-G��z�E_!q�[�1y[��8��'�48�V,��'�b�-!�j f��7�q��\h<]V6�%a���34���q,���<b��GE/��V�����«y�x��ӆQ�6Dq$h+0G���S���ۦ�����unѶ�~����d�-�rCȶR��4���:btrsFzZ��b��� tV��v�=�ڿ쟊���n)���a�ME�-�f!�!�b�{��b:�3|=M���ߧÎp��ܑc���>�q�u���/�<����U�{���髡E��k20���d��%���i��2Zd�Ʋ�hG��G�L��ZM-�(�;ь���|Q1����bm����T_z�ـ��<�_ۈot�#�OY�����w���, ��j'�ϰ7%�XJK�
Dy�lt�R�1��^���8�'�g]�h��4o;�"�|���YF�2c�BN�������VbU��B�ް�b�v#�݀�O6,�/�T��5�y����Q��j��		��$^@"4]�p��@b������mwN* �B[W=�.W4Xn��l��o�{��od/z���:\4�M�>
$��l}�U��4��@R�M�ƸO�����4�7!���s�=���od�|Or�ء���:z�(`�:������.|D6�3����{�u%�̐c��$53F�����@����A6�3���>�т��-�Y��pkR��%��Q�?g�-��p�m+W"[������z<�tnv��!��Y��_�T��o��7�{"����q���}��ya)r����r>=��&.�޵�������[�(���Љi�<��g���	����=3Z�[��FMs�!sݿ_��ݷ�aUbE��R���$�d1#s�Vq�3·ԗ��:�J����턙};_�;�{ɑ���\�N�9���
Z�+ج��������r}?����o������~ts�})lɶÐϷ�8ߥ��/Q#�lCRY��ш�s��Ǭr�[#$����^�o�q&�@���J�_�*_�1([Ȳ79O (�k.Y͉�������JP�!΀�Z0-��u	���ґJ��@�3F����0%�eJ)+lơ(�OGا�?���C� ����ϧ��+F��i_�������!��>�x��g�FƉp��$g�J����V��¼� ����+p&�������-Sr�>��H��[E�����꾜��N\�뀞���_��x��*:�J����.���n���!�x��Ȼ�����Z��u�x���bs�L�,�$-@K���E��"�&�k=[nB��~����8�ܾ����j)�����r�fs����D|H��-��?��o�?7JBg�Qf43��]��n��+��`��=A��j���h�L(G��9s��?q�_v�,��hb�ښu�y�F�x�!���ʉZR��o11���;[L������i�|R��)�$k���N߮z&*�.zw�qy�w����C���Ql0�2�#R��v���D� �6n�*@�qW'$��F����J��;VҴ6�RjE>��n���oE�WvO"�!��+�UreŪ�.�5Ǆ�Zn    ����w�.�I�#�W���H0���j�D�#��q��S'����>��<�ҺLZ���zh"uE{b6Ec�_�/��b���Xe8����2�NT��)���:�(E����|8��e�ڊ܂Z67��!S�~w�|��}�6��W#aW�}!��i�cD@��� �)��C��ֹG.j�R<�=�v㌙Q����F�����٩3��5Y���f^�\����D&`���ڡ�M�J�.��D̨H��[Ol�ƙ��g.]��wdW�8�JZi�{xǱ�$h_���4*į�.휀fQ�%![�,O��nw�g�P���Ŧ$Q�m��%W��u�ü\�/���g��g(���{&�N��q9 7�!�)*�+M�9��j-&?�!ZD�|��޿~�c4��!��.�Zy}|�km��,�Jfr�h�~�ߟ�oRj�n��a��'�ϑ�Y�d����ˀx��R�(��>$�I�iD�E���|�m��j0����3�����q�i5ߏY8D2L�$�7O6�u��|�����5u{y!�CcD��#�Fzg�]e�2	""eDs-_��5$(V&9a�T>�.E��]��W~���FF���ّ����"%[r�<��Ś�ݗ�6�.p�6�UbH|_N1��[37���9y����;�������:m�J�k_�"��їT��a��}[�L5L����������Hժ����]�ϯ���Xwdr=� u����X,�؎Q�� /5�YJ/��5���}��6Y�|;ӷs��Oe4��'�-9>%��_0��� �Q�P�����E� /:~�� �@k�C�X�,~�A�����V`8�:����xoF�a.��Y
�ֲ֑�?J��bN�V���#��=��y�@��ߗ����!�GgDʶ�B�
=�����D32	U�3oPܼ����gD���_�8?���:��c ��%���'WJC�+�����m�%�X���Ѭ��-��F��j9�0�[�K>������\�^FPDK�EƟ�A7Ќ���1\��QJQ�g|���p�|��	1U�#���<*�|�_���1�[,�����;2�P-罡�|�_�d��j%�٫�' E�� �	�6�%F0[�`b�ٌ����Sm׶����@��ܭ?͚�D�7W��*�T�d��u-tJ|c�-F}�mЎ���.���1��E�P<��B�5��Z*z�X&$�<� P4C�D���[�p��Z�&�2tg��+�JN����|�t�5�����DdM�ody����Z����Y�L�[���
�5�,�F�$ܼ]D�������[K`ԟwY��.�w><�r�\TBi~Bꏾ;�����N��@�pj�0�-� ���Vl�u!�3�|�ڔ���ʊ��5�Rm8�w�9Y�K�׋�>Ew��.�����Q		��yP�;���>)^���ub�'d��jd?���J���f��w�vx}��Q2ջ����^�|���x�To���9��T���ģ$�&v�n�ց�iN=��%�}��<�vQΓ�Ս�9�yx��lG�7�~t)5���*�&�#g���6u[��&��l��s���}y;зsx��s�dI�+31��Пy(�������]�J�@�B`�1�� d
k)?/���{k{֭�\8.[jf�d���dR;v�{���&��j�7ى<����se��Kx&���,r:���VB�!gl%����<aDJ�,���L���u�:\����)_l�����H�xFq����T�	�O=��LXYL�?X)lցH�4��s����#�d!Ij�{�:�Ty`�IO�Fe%X�Q��lb�����<p%�_�mP,��lYN�s�Ia�L�-u�mb;��4,��.ӡ���K7��AN��� a���@��E�!P��������T�97���N���~Y��j���`ĂZp����z8OT��oE���#�w���������Kd��d�x?ܿ�?m�s����$8�s|�	8XmS�̂���Vl���ט�X�d	�TL������|�N"���r�Ƌ$��-`�iMd;��F��ج��W��T� x�SZ�zg�╛#��G8:-h��w�8�3�/��&�D���_�
��S�F����7���q��'�����H
�lWRi�{;^�#EK��rE|O���,�����x�
�ʄ�f� ��&��n�@�H ����Α��$���z�� �qm���Q��r\��5.ZX�4$$��H�}E�6e�V�|��i����!����@�����(JB�A��$�p��|޽L߮��0�y�[؜j�}G�G_�u�|$|�/�<�_Xܖ�#�&0���m��j{ ��>� �!L��Z���L�}��~=_�� D(����f�w����~l���C�.S�%X¡� u5��]!��=B�8�[��=������;��[��#e&d�+��𳤥].6E��jļ)��q�ޗ��M�Kp�-��ko-5'.�K���}��r��x�t8��f&�'$��v0�Ou��j�C+r�2�@����D�ǁ�%L��uȻ����p|c�\=��0R!�,��������C��B��?5�x����k^�vi�V'Bٽ@()��Pb�>8Q��H����+�J���l�@,ۃ{�b���"Ȏā ��||�_i���w���?����-Y���	�����[�:a(�F('8��~�����t%�K>`���mJ��������-�J�̞P7�L.K�p�MI��H�?yL"�u	�MW9 �l�C�o��?��wp��+�g����:��VV�|��0�wak>��d#C D��O�8�>��@��ts;i&�F&O(�s�!����i�P��%��@?��(nJ��30�8��1��������0+������ݽ�_%Pk�%�3HS7���s�q]�b�[�F�ͪ�w�|V�|'#�������D-�ed�����Jkl������QJy��P&�PE�K7nU-5��!1�ܫ����Z��Lܔu�3��#k@����Qr��g��/��,�'Y���l~�{����e�(��El�x�p�NVQ�Ժ]�5�6���5qi��-Q�ToN%q8���D*V���H�z�JhC\AՃ���ӽ��P_��m�~�8L2�4�WR�_<҈�4Y{1���� f��fȨO�E���Jn�L\�LL�iK,aMA����ԫRF]��f�D����^��1X;���{Q��+�C���Jp�
*�V�ݪ� �ד~�����++�\�@*B+����;0�L�éC��������s��]�W zֻ�mO0I�[���g�Xv���f3�/���c�9�K� �q�MкІ�ل$;�
7MÉuɾق/%>{��.�u��c���h�o�r�?��~��Lҟt�M���=�Jj��z����{-���g4����F�F�$
iZ#���'8Z���[�˥��ʘ��H�do ˝��@Z�䶀ߺ[�#A8��4�6p���Y��)� �@9cu``�1�7���\��2nb��n�;J|��!i���7G��*����k�Z�Ch�?,�!��q&������|�q��P�DqX� ,}\w��L�',n@h?b��7��W�O�7�qX睽��3?)����T�'����k�h��H�?�I��:�0�^�-�(��k�����#K�-K�/��s�,�9�u�h.ud��U���D�ߎ't���pڽ}���� lQ��"ݑ"	��H��r+�#�[���]o�D�Q�PpH����N'�97%��W����׉�N�돇=�����SY;(�o��l�OD3�����KnY_5{[c��H2d�쐹�����-Є-��gӒ|�>��K"��=T�β���-^6r�#	��ÿ8rB�Ӧ�u��Qm8&��߈��$�H���g�7���Y��������qZ.��_��.ng��qf
�*vX�Nt��8dIF;,������r����jG�a�h��5_k�����p}����kT�WK�	���M��8!"����{����ew�����;�-!�_�9�Ֆ���H�t    5���6C7T���j�
]����aE֔������MdΙ֓�â$Fe�@�|�ys�eG�?�_|;�j��ÿ25�j�NU9�~������B�Lc�iWBI�������#�����Z��7]1�����H�����۷�Wh�MA�t�i/9�:|w��0��	�M�5�&��ga`e�d?!`]ٗ��>VRx�@����jߞ:);$V�և��`վ�\i}�G��Mۻ��'�[�9��E"]a�=�k��YC�S�Dgڦ��:�(����<v�XE�.l��|;���K��}yܿ���һ��������,�ڱ�HNwtfK�H���������U�]���C ��4\؎^��TYR)�~�u助]�Z6�D+0�Lݴm�.b
㜔�a
�f�hc!�YX��C�J"	M2�Yl��mC�b�n6iK�wճ�,�-�ƭC=��a8�Sj��^�,�8�m.D6�T��S��0��:�y��;1Cqڦg:�@A�@)H:&(L�;hlvWR*��f����sc��<����T%|�YW�����H�ش
��D��+UE���a��7�����]�>�g; Д�+����v};�ȷ�d=��v�������9��;����X�;�hD���"K��^~�\���f`���H�R�e�䧡ߊu�%�&��ǖJo���ֽ��Ip�to�E}���$��I4U@v,������d��E���*�/��)C�1��`�16`�h�c/��o�W���8˼$�Տ�����^���3�D �
e�0~�!��vSVn0:���YH�v|=J1��k��C"�،@��������zS��P���2ٔ[ j�Q� 5=\��A�6H�o���<�A_��]�g�A49�q�A���F���ɞj�����=nuîϷ�f�/�;~b^jL��0K#�"k.x�1)�K�\W҂)�N:�X�^R�뎙N���V���nU�m�	�S��q1��z|u�sO�v-1�"�t��n����i_ɬ��a 1�����0oSc��$>\�^~�װv"G���%|�%4�D��k��w���Ss9)����x,[d�����q�X:��l�i+�9���v��qm�t���x�r;�k���E&,��ߪ�?:ӶU��?t�\�����c���l!�p����8�Z�?��ވya� ]:��Uh����U�
�L�P�V\5<�N�3�nηɽ���S�M��m����>�A���L��A�#�k�p�[�}&�0k�X�;��8��{8��g�j��K֏��w�|�"�Ȱ�m,]�^F""x~gH������?�׆0
��zX ����g��V�8fW��._�������+���W�u]�.
j����Ҟ]�-��O����R���{E���H���ϭy��2�~z��i����:oن!��[L_v�a'��e7h�����F�*b1#<���"���?~�B����K�!�ɒ%�[l�}������cjp>c���c�.�Ȇ^�����I\�M���A��L����qE�iMXG(ף����wfP���;�E.Zݴ�r�igw�n���0g�vn���'}=���d�@=�?�gR��YX��H�gX[�rV��D��n�}��aߍ�T�q�^�}q jB�<�:�m�	ڶ�&�"ۉ
&j� 	�r�o���[7��?��S���l����%���8��������.�C�&&;l�Zڣ�Qw!��~�ʳ*��N���'ɐ%�6,9�V3�i���xҍꤿwsȀւ�l�4�3q��_�l��Ͼd�>xʔ���~�[�z�&��!��Ҷ	�C��n��d�Þ&��� 	8P�ˀb��4�b)���nλ��<q!�q���-\��y8;��Xs��:g��lM��6Եu����I7��h�jI9)u�G�Vo�x\>���l�Xc����ʰ$=O��\�/���s~��#��<4���[JB�K���H8��5�I��?����9��R��$I���-[{[2��ɞ���t��ܤ>G�j����3PV�h;jO�sU�A=T	Xω��PA�*�ڤ�f�h��T�YY 3-3����:���o�v��,KFo�#�0��o �'������ZuK�r)ӽ�q)�2G�.�$�Mx��*�z#4�W*TI�zXSE�������)#g�U�p�B�r�Wi��dyЧ���t&������җ����D�'���ZG^���6�P�)>~�f��B�B���ԓ{fxǞ'���9�?��%V�ύO9(ǅ6;m����JGbTh"{P"9�l���u��v�X?�?������<	��v�ɽ��,����oȗ�,�ZN�����<���6k0���[��k� �O��x����\�Sa������A���� `�,$]�`Ʋ��'�U�D��=}��9�����R+�lM�@h�
���c��;]>"�#�:�zm߳Tx|�H�0wRCq��~�+�?/���{>��By'Xbq2Gl�FFк%�!~��؇+C��[$��ﯻ����M�_�ϴ.'�A�����@-?E���9�+�F��_� h���!.��;R|��Z�Q�iQ I�����?������l��|�E�jg�� �˴n���!�2ZKK��5��ϟ��3�� �{��w$���4�j���+I�v苍8�3)s�#�:�FU:5י b4�@Ӏ�3��ϤV��Ȉ�d�j��ؕ?oA-/SIxӰ��y �\ZO�2�֍�^e�L��ؘ/�Cԉ���k	ӐT���Pggz\�݀E����`��i��r��Iؘ������y�@$1�|#,��RSP��*�,y&��B�H�� ��_dU��~t�P:�	7+\��}�|�\�JKK0\�r�?G�˾r��#��z8�D\������d���Z��Q���>F)���"M�"�Qpb�B>�0їs>Q����h��^���}<��[sҚ�����GKo���s+N�Sl5}��7z��O9����.%(�����n�-��w<��'!���V��Dr����^����$�0+o��?Y��JڹQ��睬^��H��ߞ/�M�*I֏��CP���
tS�V�(zR;��R�nٞ�h����e��G������d���P潰�gA�^����6q�s,ۄ�A��a��5ۓ�BNHrf�ݩĽ��A��+D�RUh��(v!9!�i�)��22"�8�3�>F	2����3j&7?9�4%����8->QY�:	� Vn9�/9NR"p�)Jza�So�לP誕D
���	�6�V����L.��3�~"�o���]Y,]%
���2X����x���A�4%P4�w\pI�V�Ѽ�<�a�L]��O� TQԅ,�����X-�v1C��3 ـs�7�����3
H�ϳ���sG�Ӗ6zK˭؇�Z�&W�3����pU��
�M<E2�i����>�Y�N�?e��u��3��}q�*;��� �/9-L������0�Ӓ��:�g^)�H[��-"9�[f8�p�P�P���ʌ�;�o�E��u�H	OO�"ץ!ڐ���m�!a��w#��8��K���M6�<�~ ;�L.mT
�D�����߇עa��h���	�a����8I>��|�W�_��U����� ۲�Q~���Pu�,�Ƕ.6D����b&�4���C١���+:�La��O�e�e+
�x!�� ��}�e�0�C��J��(r[�)��[�ۦ�z	��)�줪���}��j�4�XIad+Ȼ�|3w߯��Dl
[!��iI��=����p�3jIoݗ�g!6�FC�s���h��VҁT}�V��{�Q�9��I��6`7|�:A��ne��|��B1)F�������qeXO�1��q^a�vn��tL
�Q�&;]-t�͌9�h0]�I�B�(�rN�"F&�z����?V���~hqg��r ���g��^�-�E�첖�VH;ׅ}{Y�^YH@B\A$+�l�Hud�/	��N��$���,ВΩ���
�}�:��0J��v|���
�y��E�{�9�e�ٲXA�%%�Ƭ��|N����5�     Z��:и&Ne/�2&��:����JJ�f[���Q� KJq����Ft%���u����C��&�����˴��.paW>)��JZ�e�@_���p�Ix�?_ގ+��u*�i�I'Bk��p�lU/��EZ�-xH���d�	���[��U2i�w�D�I��6)8��@�b��-t�X���q��G�됟��3���{�'����Y�w�"����tdQwuyb |�������S�ev�^O�&�Ҥ�[Z����b���_�v5MO��,���Xa��0tE�˒Ců�"�ڬd]yP9Sl;��%G�;d-������뉨9����S�վ�_��GT72S#�Fd�-�%_�Ek����w�b1�h�k���Q�o���q�zMZ�7���,9��5�y_���_��_�[aNP{O���9ڇ$I����4D������e8��+�VH1���=H_ou]��u�qRޞ��y�������f�t�����ڱ�����x?}�O&��~6IHTϽ���V��$#�I`�-O�F�Hhrۗ�.��h�̯�,3�#d��O���냚���&�<�	�^�^���ʳSK�9'H
4�jT����*[S�̄��{�mQ��F���W%"��ҲmO4�D�@�����3ӍRY��v6�k��u���>Ҭ��op���!^l�J�QΛ
/�?�Ɂ���*�q=*_�8J���'A�fp�GV�'� ���1���-~-x��tu����r��Ғcm��z=���V�x��0-9Զ){�dL�Yլ9�1�M�_)�:�Ӄ�
LB�{�2��N�j^p����_�Әͩ�ԗ�GQG�o�^����}~^7��F��^��%;��J���F�|�A��f��1_�����M,�/`�nf0qm���]�}D*0�� 1�'�p�AC�9��[��,����*ZM.1�&7��r��ɨo<���t ���l�M$��
E��+=������M���Q�����d����ۿ�CU8�o�K�q;$�j>vƁ��\�%���P_wg���$��Nbh��s^�f.2QHm-)���/~�_�H�ftk�u�՗C�O+�����̺3Z��Z��ʧ�;�"ế�pva�-�j%��d�d|,K�(.� ��)�J)6N��h!^#V9ݙ�!&_���JUP����,aZRjyE�xc�5�,q&�"���Y�L�f��x��	1���jR��z�$t�e//1�a�հ�~7����e�b�$�;*�����lY�9��r����K~t��4��|��2�,���`6OFP~'�V*O8�Ғ�R��u����l�,�
&Si%o�k?"ה�L+S�CG����n&�<�M^X�A����D{�(�C���㟽2Â��/Z��f�Q,�t<_�_{��m��鴒�L+`5UV�QV >��j���c�t�V�fq��?�(�-dH;�8�9І��O�hVؿUW��p�z��'IE7�}����ݹ;;�9�e���R�9�vF���$��{��yy��P4��eYiC����@�cIn����K�$��P�ˬdA5b:��l6'I�-15�a��T���z��7��ё2Y�*4�7�����Rx����\���/\橛�^��.�浥�Dۯ� 7ۍ��	�'��7�G겖�����Wk��,�G:�.��Yx;<�5΅3Og~�í-�����+�(�Y ,Gp{�dl�G�����q�h}&�V�ݦ=��}_���#��Y|�B9�|��|K����ii�Ňu'�C�����-��R,��rx���ڷ|;��G9��nH���y�����kh&�f�A`�R큦l�11��Jb��2)Օ�?�zz�m~;��$��!�[�~]���m\�˲EG�prf y��v_�q+���8����-I�F_HB^\�C�VH[|�C�M�̌�<�Щ�R���*#��.B�6�bL?���ޏ!7XZ�e.+�r�x}/�`u�� V	���"�g	SKV��ju�I.�
b�����s]s�d�	�ؘ�S	V��
b:aƗ^A�S[�Ӷڱ�[�;N�Nv�����-oA��dͧ�H ��F fm55��G���I�vc	S�&z���#���� c	Sإ�X.v�Z{p�}	X<;��Ug#S��?��Mv�k��CtY�}�'I2We�L��˽8�����XЯ��- B�{��C���M���®���>䧆�nĸ� �ջ�-�˭�E�hh��oLO�3x�͌ŽR9|��b�U��ӥ'� �Eh��~;�)��u�=k���W��k6L��u�g)��%϶��K�c������N[��<V��[��;���,��\����2���t9?K�E��I1��31��ɔ͘1U#��R~�� ���@������p�� yy9�R٬�`M�@���QӅ̩�g�C�r�+�>�SPR\_f-��XQû9cZ�]X1a���j����R�-S�U)��gWtX�D�.&��i劒�\�;y�.Ъ�
 ������Z���&D��b%��$~X��M�`�i�|=���z�>j�?`���w(8��ã���w��w��\~�.�Ǧj����x����_tw5�����0��๕�k�o�5�{�\;����ɯ���g+\�#t_qy�#�Y6�K8D�TE�^j�%�u��ceP/�)e#P,��7������SL�3�S���z�5�&��O��
�!$
`끯L�Rm�0�9��̛����W����Z�46�=:W���գm;?�����$7��s�^P�y�X"�{^���sf:Xx��oK�W4DY�A��`t�2C꣑>�%A�4�Qh�S&���&�����z�'�k#�H0u���K"�Z��b��L���iU`��Ic��`�<�0�{�������UŇ"�U�p^v@�c������x�Э��(��C��Hl 2l��Hi�_���\��s�W��}�!�Ҍ�u
��h���n|�˟."!|��c�o%�
���h+�$7����C�~\!0����ym�$�Q�D2_��	�T��V�]�󞵫�����ot+��{�� �K�~v�� 1H��q�� z���� (��!ե�y\�oj���҆� ���΃�CEC�+j�
�F��]�#��;��� V	�>�(��rh�L�&�m�AmV�.Y��7���%�T��vH��Q��Ѓ��D9__�@�'�LVw\�$�*�b�`�j3�����@w߯�l��Gp�m��ӣpj���s��	��E�!�_����f�� V	��V@+����E�uN6�1uOZ��� .L�oa�u+�'���F�w4d�bm��������d�J� �[ׇX�m���
%�e�\k��!��D���+�����b���K-�BƎv̲�Bn�Ȩ���3�-�!�=����a�x:�����"L2��&�9U3ͺ���ס���i�"�PU+<��z�a�̋�Z�Zz���P���K$z�[c�w?W�9�j�X&���1fҘJQ��]c�]vͫ,W��X��3ʌ���X_�(��0�ﱕ*5�\��V�X|7��is�`��{T���+1. ®ƤN�n�S��B[��,�,[]���W���;m!����@�7[��|z-k�^����Ajk���J��K�4	,5���zZq��� �{Sa��js�[z��56n��ԝ�����v���K˷��*D�Z�em�s��g}Yf�AC��w�¾:n�Һ�9���$�x�?�������C�� ^�w�[�`@Sy���C*���mjjf��\�k\���d��bs0	H������h�Yb��g���v-<
#��H��~3����a���g!���Z�7@��!>jUߊGj����]h���5d7���w���U���f�J�ei���w��i������Enq���c6zf��WJ��L��tx�>$>N/�R4ߏ]n�O5͝�� tjHX�m�8�����W�7u��>;�3�� �q��v#�dD`Ր �Q�J3���̹�V��)MBbl���YE%`    ��Q[m��'�|c~��"6$���2�S�A~�B�V�D�Yԛ��
_O�69�m����2��>����B�>��������񩧪ZkpZLtc��y�f\d��6я�}�yU{�)]�h��Vjp���D"�MN�f��޾�"ub��qn籑�ޣ�i[ف�q�ML�7r�U9⃰���v����lh���	����Mm��ޏ�[��+���!��u�P{+^�tS�E�F|.���m�жl�z�8�g�|&f���v���fD�ņ�pT����$!���?���S��E�f�Ӻ>=qk8~����e������+m�����/<"���,�/鉕�\#�A��$�n���䐇L�n'i���'��}��ςQ���a~���K.g���b&�j�s���w�v�z,�I�߈2!0q
jd�c\>���OR��bN�A*N���!�t:��P��jA�������}1�<Bbf6�Y�hJ�l��ԩ;o85|���%p٤������`�# �OY��]kdS��G��A��6���#e�&4�h<�B�~!C��|���bC�s1��!�_Z���|�h{Pוֹ�_��0��X ����{Pp������I�!�D�� r[�+}%<^�Yy�İ+D�Xh\ح�9��ucث�ӑW�?�H��nz�tW%L�1.R6}�X/w4��=5���?��4)��9B���.��o�g�N1(di�F��Ѷ�l䝈.��#�I�e�p|ݿ�K�/��D.���V���u��:p�@MN8i \D&����,��AZ��B,0����=�l�!A�eVE�D:.��c�ʜ��+k�&ؖ�f�^�w�ϯ��D>�lP�#6.W	�ݽ��3��`�p�`o]���޼��7����~�ZVWh* �������È����~��� �/�~ֆ��p���+����A��P��v�A���8�iĝ��l���bsWr/3C�ٚi�n]�$��֘.9��U�1 ,�x��֯�.�WM�Z0ϴ�p��5;��}D�<8�>W<T�]�I0!WaW�܏
Kd�u���:H.%������㓠��t'��t�ZJ_�v���,L��X��-&݀w�֛M�s�r������G�����+NNS����N㟳�u��ϧ�>
�QxUϞ9�hk����R��n����G�/�L>In��r�p�}-����Ό�}Qu��b0'��#��K��-���{9>�w���������ˑ���B`����@�ʌ��B�ؒ4�݂��BQ0>-	ƍz`�u�F�ucI�)�X�f��B["�a3���@�ק���]�7d�r0n-���^U�?wW�����D��q}�=}��S���䕍��l,Q�S���]e}���b�˭��2������������5_^����!"�*�%sH�P�~9��k<�?H�.4��D9����E�ْ@�����9A����$xf	��l |)/#!2�4ΰ��������4�q��rq�|�����]����h��~���p�L�6kWH���s�DFA��4B�)͜hI��F:�r�͑�Q��m�N���$ܲA���mns��*��e޴T�Ԝ�t4,b�+�@������焈@��Y�����L���lg"��6�� �+������-\x�b�!l����ᗲ�˔;�Fq�%G6�b\8	�a5i�ۮ����w!Il67ў�����eLO�;�q�a���IQ���v��������PE�P �=m�� P���%^f$-Y�+�M����%�U���]�yW�����5ʛM!z�Ws%;�i
�4G����_��zz%�9�2L/����G�3қ�c��%)\��̤}vI* �A�q�m LK���h�e��Uf(�'==jt���] _�'#ƙǵWG{rI��x՝C����%�{�3i�|�����m�,!i?�ׅ݁�Ґ���XїH��2�-1k�l?ΙՐִ!l��C�]���@�W��X~H�_�!�MC�ǡ^���2��{0Xw6*a�����j�ߞί�n���I�̛pi�6_���/}#J
�U�  ������,��&��L8\��?�p����E�@N+��!7�]E�o@�tT���O���ߗ��7S�K})��eCp?��u	x�q��@�/o���)��rΠ�/�T�g�1���h���x�UL�Y;zbh�zqd��ni���	�ܴ֙�F6�u��p�؍��%�������5VS�F���yc�J�a`�9�(m�|�R�u�<"���i�`���L�8�vԖ����r�%��]��f���Z�V93$�h�1uǭ�][���d��uB_Z��/�0��<��U�F��;�e��l�eoWx8��k������U��2�K�t�:N��лt0�{���0�(�-���n�	D�i��A��u^�íB�mx <|��Gpm�ל�@4H�|/�d�«u~�l`��:R�c�f��i��Nћ�IA�p0�_�����a�P+
{�~�7Q}.2�H��ץ#�6�����I��4��o�_aB�G)��t�&6k�x;�Q ?�͂����Gk����BX�7F��WT� 4�m}�e��6��a�نZ���
�	�
�s��a��w�Н/0VW1�r>��p�\4��$
��Kc��E�E�LR���z.)�"��.�[�ΦQ��t�~D��:���v���BX��G�	�Տy��q؊s��H���ݒԱ���*���swz~��O���g�x&.���ttn�FOE#��&v�8׼���?:H�C����+<���*'����n!"� �x��W-�Õ��?�,��6De���:��:�啬$��į/��w���͜A���� $�H]�c3b�΅-+��-S�E-�^v����w��翑Ӂ̀�U��&�Ay"�<,r�,"I:p��c�������_װ�Xah��[�=��Z$�$��P����Kw^�%JOlbf:>^���<�4���Dqb�x9́x
͈��rx��C�C�dk@�L��ZP�R��eX�)h���T�3qt�ą�� iC�k��ӯ�C8�Kf�}��/�D�������O�$�^�7�F��M~��B>���B���s������e11pPj��q��)Aڅ�r�v@��9J�M�lwS�l��=��θ~p�v6��d�W��x����.�%c#��<��V���5���l�� Ej�_dY���3�Z��/w�����Y!�զ���%hڤ��I*�rtq
��6D�f1B����$��
�	�sI��@��"��]���<4r���ހ낰�_d��՟������Z� !b�������c��:����%;K�>���d�@�
� x�����Ļ�tv"�k{�g�\avz�@�'kn�ޱ)�gH�m5�{Or��z?�qI�C�ޑ��ط��J��_�����[�a���8�,C��B��Vl�`�<�5��"��],Gau�w�Ҽ��{~>4�"q��W�~�V-�U��@�5���D�H�fM`a� ��U�y���!�J�[����2�������&�SuX<�o򬡀H)D����
f�[��h��� e���G8xd�7���`�{�er`�eV��dQ�[M�Ȋ�8wKR q}�m/�⬈� g��=���!K�E��Jn�P��5Tγ��~r�{kv:_�.�_�����K>_���N�z��Y�p��;V�����*t�B@�F\I���%�����حȋ�Tuai��<oLm���z�ֻo�|�m���Ø�����!`�Ź�Gk��2�vΛ��"^�r}n~��!G�yw���Q;t#.�2N��:=b�v�E���!�F�e�t�L#�!2�GP7���i�e�ڎ�#[�c�_������R) ���h�1��im>�]zj�����_���\�_0�|���?���X���߷g�����6i@�(��]�"�Yo�-����zL��@H�x7�ӒW�Z]$~(�H�4����$�$�wV#[XO��    ��s���OL���39�t�ί0rS��ma!��uk���9����d3k��5�UG��֣I<+�#<�Ƿ}~웥�:�p��ϥe�o<�qhر�<_�wۼ�dA�������pa�m<ӆq�S���)��%k�
Hx?kL-��a�����I}|���*���E�a��wW��2)���`��h�<y&�e��:�"�^��|�<ou*�P �g��n)/�0� ,i�%�>�C���4����>�����f�5�/��]��X�>��#0z	0� =&ۈkeE��!� 5���a������@\�����|ǛV�����u���z�yZ��eY�D��2l�i��ȴ E^��4�d_�q�T;Y>ƴ�E�f9�)�- B�<g
M�+i໋���ԛY�J��L���b ��Ժ�7JT_拪��KK;K[��z������hi#����z�jա&���Gں �~U��Z�m�Z�1��9��ޅ�o�N�{%�'c�QÒ��%?����U���Ħ_r<�7�Q�FH%c�1�P�ۨ��C6��h���y���Eؓ��V�����q���i��lW�%#	�e�R�X��q<Ey��܂&{M=�"��k0�"��d�I�jy�ѭa52Έ�Hph	��@͡N]�Wp`Ѹ��;��Y#��c��eQ�O�j� �����?*�(�lLkh�� &�r�������nfe�Q�q�F��0c��4Rw����k֮���YM�6��v����7�B�����1�6�Br����0�A���'�FO��@��&$0���_�S��.���p�X�7�#�8�.�ա4�����7��'���1`�.pc恏�o��<�T��Z}:|�������&6�e�fJ�8?F���z!xy��^������M�a�"n��+���
+�6W��\3�$��|�	<}�P<^Fi2������s�i�B	���'�������/�2��$@1�lo w�vw��; ��4Q�������� `����%�#׼�_��c�Mj���n���|������|:��E%�>=�sF\, .����m��V��V��)�V�0L���;%�Ѯ�[�&�3�a5��ӈ�>����l&�� #B��e~ ��-�8���Ƈ��U1��U�zg<�A�m������ph�#�nk`~R��qd��T5��%�� 㧡jr���u�uO�E؊��*�F�����/v�R�ݗ��@�q�����K�{i`�������@K\,IG2DF#�h+�C~�*}�@��HW�}�1Q��$��`��������i}����x���W�tp�5yo�����;Kn�.�w�	6��������1��c�UX��۟��=cL;�-�@�(��al�'uY�*>2;��1n�⠈K ��-���};\����nۅV�����Ե:j�=��bm'��K���?)�*���������Tq�$�]�SE�<�I��� �($�|�
�T������ÙSd1��~٤���W$-ڇD���;g�m ^ݥ)t��e-��β+���a�s�:#_����2_#���Tv��S�|S��p�8���H��Y�
h��\j{8�fVltﻁ[�A=�b8腺M��⣝#�p/��o�����z��Z`攙�����!��5���4]l��fE���q4�Pnm����%[C�qa�C��#=,Fg�m�j|�enIM/I�X�Y�XV [c�g��d�M!K
dt�q�#rQ~��
WcMK���+���hl"�m�6�-�_#�:��4�e����F9/V̢�1�����_Z���������0u���(���Q��Z9���?o�$�~�[W�ǜ�=˗�ʶ���L�G&]�֏��>o��G�� J�m�-�T֑�Ҽ�JH_7ZJ:��t��/��wO���V��Pkv��h�ql9�-V���	!m�J��Ï	�eXݨI�d9Y��@��>�z��p�c�8������@&&���S�D}���|��x&�#��p����0�$Y��c��`A���4H�w����
�7l�zRCbHf��L������Gx�m��b�h[��f�^��8'�������_�q9?�a�nk>��vDY���������â>ooay	G �b�����vW��}X��	9W俿UG�뀋���A����:��;P���<�Jh������uA��94��s�%8Y��=_s����
d�)P	z��� ��d�-�64p���a��n=!iQr��x:�
�2��4ha��,Xe�ڞ��]aL���ԷC�2��Ӂ�S�_�fkDT�4���=�a}��9�[9��$u�[y�|\��j��и�_���Sw���v���u_��4��İ�)�Q
8�[���(�}��j��S`��ʧ�jj�Ӊ�!�𹿡{J� 8�6v��s}�
��-�w�i&N�NӨK4��>V�>�\�z�����a����%@b}���!r���|��x�����f5mJBWZ)�h�<�)j%m���㷗�Af^5q�8�̐��7��'s�U1�0�beni�n�e�/E3�\?`���5�֎lgx�����a�]>���[DTƑ_�k�aXϑ���;��w��T��y�P�mR����ߗ.p��.��v�lU�rn4 ��������3B���Ӟ3����k�
6^��U���ɛ^��srK�W ����!kRa^?�5�e�srj�F#j�Tӡ��It��ܙ�"ie3m*>����eu���Pg�	B�weg�p:p@|=�sY�����Z��ܱ~ż�
3l�Ȋ�ˇі�v}�|S;�`E�A@�N�g(k����{��B��@�|΂i���ٖCL� ~�.t������@���e���W����ZЄs�SWE�]��٘x���eTDiTɠ�6�`D�awsB�Sh�t�\���}7�j���@ Z�Z_f��H"ՓOBЎ�E�!b!]��A���3]�|�+}�;0�K�H"�I�\�M�o��+f�=���!����#BG�|����.E�!�g�!�ü��t���.�[xn�G2,ƕ�ޟ�o���6�̮[��d�r9�`d�ݛ�bTԋ
�n�!�@N��59k:q���e��ޛ�`��ض-�6DH&��8�o�����7��L'�/����Q��B�+�2	� �M�T�8s�^����|Ѣ��[z~�SX�֒�ȣ�Vtn=O���	��豥� Ʋ�jCv��@f�(g�I�~��m�d^my��V����ﶫF;�J�a�׷.���e�eCg_�tچ��kOŶ���e*��Ęן�o�*�a���~�s/o�B��]��2�hF7����۱d�z���v��Jp �Is\��o�ͯO�uC�]%l�|o4n���ӏ�:���X�;���N�_��[�Y<V,xD�w��u_�p�l�����z�Go��d}|�UX\n��� �����6	A\/fd~ó�����J{Y���O�҇z2��Z[�P(8����xݸ� �'���ڑ���QE� &F�D19�)J��N���{�}��6 �����3/����1!	�a�Qzx�Uj�x���u��k�
RB���m������#W����v_�t��
�+l���P�9�����\#E6�`l)�����=_����s2uMT+��,���iZ5ѼQn'N��nK�̪��:-zf\wd0M��	kW�o�����G4�;��t���X,Z�+�Xڮ���)�����;�a��
.����k�|��uj �oJ����\1��eH�W̗*�B	�ߚ��4��C�%r���m ����c��k�\ū��i�-�z�Z�^	p��V+��d�q�ғ槿��M�w5,Ki���ZL@��7����y�4��@��F$�].�2��}�/�s����4N�a}�=?E�n���(�+Im�۳�U
S`p�_ '�����T��e}��R���3�$Ӹ����ZAz~r^�6+�,3��Br~�5'    G�SU8���a:�k��I�n��!��?������L�/�ϭ���Z)�p$f�����pϭL��E�d3�����6�+��!�!�������>3�5s2M�,3\��5�ۡ 3�n�\�
+�`���@^��P��!Kēfē
T�x����"\�.�귢���A U�ϧ�Z��U��s#ٰ�P7۹k��-Ѵh	��ϣ1ݪ\͍����f��t83�`������\�7�rF���č�Dds��:�"�Ҍ1J�V��J�I6O������a�.��Y���k����I��Z���uե��F	v��Eչ�E
b�Lv�<f��dʬ���3��5��};༥����PD����G�ݥf3Hk3>N�d4�~+D��*X�m����;�Ψ���v��� �XA�[`RP0�⼁R�M���#`G�2��g��0��ɵ��� �w��m�����!�:����|ő�>[:8nѧ�@��F9//����h(���]����MJ�����}�_��6��������W��7��#"�q�7����aY�u!��R�L2׺�^��B�}J(��H�3wäD˼=�/rV.��(�.���a\cČ�҉��r���	�:��n���Z��y�L��~EZ^�Ƴ�85 )S��
.4�Q����0Z2�Ǽ>�Ӭ=�%D�D����s�w��ld�E�$��Q+�s����:���,�2�!�B���y��3�%i�]Ǥ�>h���'"�4�� ?����џh��;��J���_H���Z��wzܭ<*��gW�5܌�� \�%�[Mr�q�{�S�~^x���\���.|�Fgq�$������M��J����Z�7ZPwJ�J�`�Pi����?���O��d��.2�#_=�i����}�1Ҥ�<�0�՛�Sq4��0Q,'yM�7j��&���ps�<��Ͼc����`�c�-Bx�BǕ$��@X���wL��n�\�"އ0g����5ґ�dpQߒ���|c8ܒ�uג.�j�+}��R�7���S;�J�|�����Ex<5��9L�5�53��!�>��P�pg�1�6 ���n������yU8�1�9�[�o�W���g j?���֔��+�hR���{xf]6��!Y�|�i�����[�9�M��MЍi�w�&���!��050�	>�M��m�uC]�9�� �	�E7q뽀q,БR�����:�I�Y�9v<Z���x}\G�P����8Gw�bP/�ɨ�qi�;θ�z��Q�5���x�#�	pFL�Ml�G�DYpF\�&���\j���6�<m�E�ސ^���&~�#�d�����������e»���OxH�ُ+��M3�p!W�o6��M�N�Xq^�bna�V-��'�nH��x��bÌ����D8�s�(׾�|����Ϋ�?sB����rۆ�P�=#w7���v����qP'�0S�IZ��p��wF����)��|.���	b��x)� ��k1�{�ʜ��W��O�H1Dp�O7Q^���P���?#�6��V��7�8�i�2m5�u���-�Ve�3q��R#]��.x�m�dQL�� -񡳭�}yr� 	j­��o�|�G���7��H4�"� +-+嚒��-�Q�p/�C-q�����������n*2q���1b�/�O�΅%��Z�>�n˿�02yS�9�c2�nҜg�hy��'��0,�p���{�&�nG���TP��4�є�ݔ�є�����:�j�����-D�б��k576X>G��52�nd�Ih$��|�i�ty6�Xn�A���Zh�o�0�,Nf��Ħ�k�l>���a�ml<yw��d�Q������§-��8J�l9Y�%���9�����W�l��g��S��)�2�ؚ�0榵1�{k�8-�3�v<�<D�n��}�R8�[~N��,~2~��9�nI�zi�p&��Ʉ�g�����*rS�Bd2��l����&�fQiH�'��kk3y������,��$���5۷�&��|n���c���*�l(���pP��l���X���I� Q#�f#�J�A���d�F+��z8�w\d�ؕ(`H֯���Z[a1K-�5�0$6�k��q"bC��I��!��b6�P��l�n\IF�a���ؒG)C�i��$n�Af�[M���.EQDjE���F��\䑠D"����k�nǵ���c���S�E�6N�Jܹ8�q��z������$Hɩꗹ��"A\7����u��-.�3)�5�����HΤ69#�?q�39������i��V����s[)?/Ͻ���y�������T�p�]B���t����>�z�9���x�,�Ne3m�J�϶���g�">)/�y�6���3Z�:���O���[b��g=I�Y���d����M��2��;o�_�R9%�vB���!4B��2$3	���5�����%���Y�Npn�?�����8��	��#m��tقn�xa�7z_M����̴�X��
_�%s��S7.6U�F
� ���-T�Wh'����m��<FW�Xψ�&Dq�cd��Hc���ӥ�cLՃn!��c����xu%���"X|oGt�?����RA�]�&T@�4!n�Q�~�W���A���\�XV�\B���7��^�w"���6f�y���L�~0>B��5L�R�/���˵�� o�_�k�c�\B|�Q�k��G2�I��<����wQ��D�������gz�}����{�(b�$0�����lh�4ҴQoW�"���eX�D:YR�\�칷mm'0+r�N!�db[��K!S�� >q�=~r)àv��gi[�'�xBܪ!4���NS0� 	��A�Ҝ�?;�yU�� SB��y�߇�?���
��QF$sOR�H茼ՍEt(!:t9���7w�[�t��/��6��Y=�,�t�c}=_�W���yQM��Uy�
}b�̌�QB������Em�BA�����a7Q��@�h�|�f�{���.�rD+��k$(��(	6�*.��f�h��+��k��:V�~#���.=C&�'ET]K�a�.��{������Z��مv���A �Hq��aqM��CI}(�12A��F�J���I�
 ��ﻕ-�U��L %U+�#��y!�S�����ܥ��GH�#X�R"�����A������i��y��\�	����\aoe멂����J�2G*8�o��c58� 	6 qR��T-��3�a+�Q���R����@2����!�e�Nj${�8�eؼ#F�ԙQ�:p�4�ҥ9䢔G���*gmn����[�<,|���6�t9t�Q!��������+��R{-F���hE5�����>�����73������8/�8�銗�M�@��m��+��IB���5enEuRԜH&���dp(nAlyM/����R�/� ��j�����O�Ѷ�)~��BBh���|�%#�0�'�J���U�LO&=n��� !F�33�aP�2-�?��"T�,��V���2�P��[�u؎@lb2,�Ѣ?ź���SL�v#�>�`�\m	�-�/����儲zp��1����E�	��Bw�r�����`P��+�ʤ�X«"�ђuY-1E9��B�]2CqK��Xs�!Z�B�, "�2� �D�B��TD"س�=�ȴ�7�l�`�2�j==ݮ�kwG��@)����]��J�,RE����4��fW�HC�9�o�h`�,t7�����}�!8�D�pR~5_��;pw������@���K�?It�Yl	�I	lW�jة�\k9!���	qYѵ=6�#��A0�n�%5n�=�ާE�mf���7O�[k���m.j��s�i�+|rzH���kk���elX�
(��Za(�e�	��*��.��X��ꑖ��Y����q^��� ��*%���H�$2��y��7���������F��7�b3X:�����+F�k�xs	�����+Y�(�
�4��J��иΟB,o�|Kӎ(����3d�6d�fo,P��-���Zޟ�v!��y��    �"��L�b�}Ebl*/��˔y�)=�����Ӱf-Z��|���q�s�"'U��=_�Կ��>��/��o��Eo�UGt�o��n��-�qk����V��g~a�w���̾�G7�5���2�yA�f��}��Z�V���=!�'�m. �%����<�|�X��~��i3Ѻ��$�R�����gm�L��B������25Ǐ����}�j]`�y�x�?7�G�J��KqK6q��V���-���]S4���6K��o��[��u�Nc���O�ax+oj1�g�}S����}U?�
��i��	ݑV��k ߦ���iF#�`�4o�o3U���0��X<�Zq��M��}`H�X�O��^���S���f9�ѧ�*	ӟ:��w/<�r{��dŃ�u(�z����DU�ڮ*4�ֳW��S?R�ԫ~-��CGP�6ڝ��/��� u��:.�	 �Ǯ4q3�V��cy�M�mr8`,P�6�S�?ڐO5�G"��t^OB7~2�������w�ݼ9�(���|F��7w�z�0e�p��*:�m�^B*�O�կχ����WhZޒ|/�bq �h j��T�;t�B�_���r���=��W��DDttue8�@Y/@�\T�H�ñ��e�jA�P��h�\'Dp�D��L�r�E  D�\�gF?8y �w��`��']>��b5A�j�x���T�>
Ǹ�Wu9�^N�z�V��eA,ӯ>��m�`��y�4�DU��@�b��ۖ��s�����Vf�Y���<�9���d��x��[�ٯ��dY�S��������ebKg	��H�ԓ囟�	[Q��	⷟=�'v���G�FD��5(�3T�1��E�A���3��T&�6D��H�[JrCA�ԑ���`�Eټ����*��5K�'Of��:s-V}���INE��c'}k����}g����;qP��-��E�z�u���D�فL>Ke*��� \�M�J��r^�'�8T����u/��*d�;H�lP�7�4N�K��ȵDz��j��a:�ȢGp��ן�缹}�ķL�/Cs\��ˢ�1�;|ܤ�/BmR��y@�Diq��/-��?#��O���ȫ��{�K~�����{��_��+�l�PM8�0X*����}%��0��k(�^��[2aۑ�����m�`C���q��8aӑ�1���wO��i��ȩ��(����~�D �X�	79!~�?��.Ss3�d��=t�2BX�{@�E��ډX/����
��0�wB���!����J��V_�#���w����8�8v�[h>�2����f|=�[Qht]A���
p������=���[��i��d&��u�����tp�x���a)�a?��1+�����4����_9�����%p��s�ތ���^�+��=�plr��z��d�\B��\(I�:r��Ě8���I��+h�����29xd���w1�X��S�t�gm-���&%��ӫ��/�<a��.y��T�~�^�N(S�d;��3�<�����̿�,�\�%��WX�'�`������6&o�b��0enx==^1π�p>�i�Y�&��	q�0�{���A9s��0��.+�/lF(u�~�'N��9#ꥧ������4($�?"���Tc��7f2���z2ɽ}��}_L8�<�h~u{#Nύ�Q��^aN���(&�����!�9\Ոn����
�s�њ�k'qI�5�ڭKۺl�j:,(�7g�t�ÊW� #��3]Z+�_��3�q��Ly���F��O�m����m%7�0�օ�ZRrQ̙sp0GS�{�s������1w�+���4T�*�$VEJ��%�5�sU��ܿ���2r���C#b��|�]3s�#���l���:�fŵ/�qe�[qJD\�^;������|�QKN�V�|��D��~ ���(F�n��߆���%++�[��pH؍�����~����7Kܴ��)�� �$J��s�Jd�_�w��*A+^z�/���C$�\��ؘ�#���"���z��t�8rD>s٠�<dۭ���8���!0��oHMl��BY{}r����c��%�z���	(G�e%�@:ٳ����}VO��i�`̔�{�/�7s��y{0o_t�BX����,�/n6 ruq��5�;��D�%�z c��TކS�04 z�~�����[A���L��6ga���:�:��jZ�矾�Z4.{e0��_���6v�j�)F���A!,-e<5jv�!0ix�}�-oE�g��/
�{?�� t����;g�X���2X^�EF�n�/>����C_fmpݘ�F�T�nb�w�HFɸ>�O�ʑA�@���~�J��v�����Y4C��s��<���Α�l�~��7�n�c�D��?gJ���ys�HJpF�
�Ք��(�:��q����}n��^��y�{�ۖ�rAEjNv�]�TO��4��$��Zy���E����z/w��繣Ϋv�WF��E]O{"7�D&��� ��b�=������ ��v�k�C6��G�>_G��ρ��ԝ�ZG�;�����<�ծT�F?�=E49��=��{���?0R�?�l��^�(b���~���Iy�J!#ڈ,���xx�D��	�����˲��ϺN�g�u��0~j����Y]�3_7$-0'�|�8LP\�VqUp�D�#V� i-AJ��^��k��s�
�N�5�ƫӓ���*�������Qv�0̫=`卾䍩e��,�0��k,�CM��"P���j���J�M}�D��?��~zg6w#��q89KX��j�,�*1A��,�ِ��^��֕o��qA�q���2�������5#���`s?�N�R-�H="���׋�X����������^����.�+y�W8��D��$X{�y6ڣ�ތ�(z�{��90��6��K�߰�k�0�Q����!�O��@210<O��v��������������T[%�[2Fx�l��2��Z��K�$���A�:�3�;�6�gN���7޼� ���8�֛��}3���٤��x���O�׿+$U���qm���E�w�8�j}�q����1.�&5����񻲍�/Vj��G} ����fۣ�vR�nwG�+�&V�'����4��<:�M;	O��셗��[�IR�XB��t�t���|���p9�9��"��n:H reg��$<�� 5'�/@�$�>�1{�Q��A�c���Õ7Y��0��J�X�?�߽�k���l�i(��XĈ���~I���x���	!����v<��f�ݜ�%đ����[�9�9ܝV�3�l��� �I�k�9���z!�|5o�����C̓*\O��	���	9~{�=<�yr��N��Zr	C�}�<o��z���Bd������B�U!!�
A�x��r�wz�C?MmzP}��(�n��l��)46�^���?Iп4���s��~��VƋ�BD �4��$�X��ƑC����k��c?��	ԑ/3���:<�J������m_��ݿ��?>X���I�[$`��z:]�����گ8��J']uG��бn�����|N�K���Ő�D�zz���J4�X���1t���?$:�:^{}�%�E��ā.�����-pv�`��?������k�jQ�|�s��Y��E/6I p<´����^����:�*`������5kcL��^��(1sX��y���рe�h��y	��36 �)G�<��Ef��
Y��� F�n��������X�n*`��d�_�N��0(����	V�1��#|��J;����i� �C�ې��"�����,rB7-��6�����`��zM"�cv_��֠KY�C��wjIv���M7�䗻� S3���}�5���Vӿ��,8!�6���p|?=C`��/�k��E�_ED�J�W�&56�&����!�[s+}��nۮ�A!��E;g<��?v��N��q�Cƕ��z�5�Cc��$��<2i��Fid_���Mt��M/�     ��{�������N�h�s�l%�Px?�&��^���k$b�O�&�HV���|$_b��ٹ��=o�k��݃�C��W�a>�i��n_�a�'������R&� �H�� k����uPN!�r�'s�P�s6~��_��)�� g����ݻ�uI.G]�H'H0zA�N?^�n���f����՚4����$I�  �w��5m/{�d�yϽ�d�9��y=bZחe���&��
R���m��n�zbhg�Gqc4�<vþ찾`Z��:��A�n0�
�g�Eꦦ*g! 1�cY<�>��Cq�DD�r�a���%8��T�0U��8B'�$L�����y��o���5���9#�x�����؁�x d�:��{z2�%�F�zd[gf� 7�3>��n�|�՘e<�k��
P�^.gL[g}��FZg9틮w�w~�}�C2OH5��n�'(��>��z5��zs �_t�!��,�њ����>��A&��]) �$s�&6{+ң��Fߌ���m_�U�M��Ъ(IZ���~�19�� ����������a�+�'a&���Kl5V���2"��]R>l��l�DFi�E+q`U���[���d��d����Y�3���|�_X��90d�����i6����y��^�����L~V{�2����A��g3IB
�����	��L�9�l �M�,Wk#� H�(��lw���+x"�L�X�!�m7����L�eiv�����6���C+��Mo��� �3q{�c��EC&��R���é`�$�ߎ�� ���x��Yaۄ���0̛�{�H�M�k'����2�(�{�sc�,���������~v˒IF�(�ߜ�|��1��	墥�K���{.�s󴓘�X:2?�%3.�Pآ���0�/�Ӂ�T#~��HxG[���"7w�L2�h\�vh��i�HY2��ӹ[��[������{�����kei�2�~K"����?j�Մm�	5囎d��f6\�~U���]��&y ��#}�k�W�o$-�02VS]''�ꖲ��-��3PV�w�I��I���'HXԐXT; 0=��	�W�?� h�/�;ts�:���:Ў���hG���b����A^�ΫC����Y�`#�*8�[�'_�±��`�G�"�q�?����ߟ��ʶm��ә[��6��x��U����E�	��?l!��T�vM�:e���M����s����ch��Lg7��V��@�P��O��ZY�����̶䗱�'����z�[s�뻄h�7M'ǀ>?l
�*q��%N��f�X$��O���Q_���E.#!햸�Ԧ�w�����J�yu��t\�Q���Ld��$���|�����
�UUA���m˼a�Yci���B#2 ��k��C����@F�W�r|��b�.���&����:�p�'�ENb��9��B,�ttn7�c�`���j�s�D5r��h�H4��t�x�� ~�|MTҧ-�0�� `���,_D�x�c{H.����]�7&Vvd9�:p�;�e.��	��Ci�:�9�m.w��*%��8�Sϡ��謗��yn?k0�"�"�KZ�=
���PF=&EYKEGlcNl�Kȩ�u|΃�q�K�0|v3L:Ӎ�s&w��t\1{<9�'�Kc�ܞ�
��$��dRKLĀ	0mb���E>����i������F9H$�����bRL*���F�=A��-�%��2�Œ ��,����?����
ټ0V �<P�!��c�#=��жJX���	��u!�F�����_pB����=�8C@ٸ4���|��mg��[���%ȩ̮�%���mz����RvCƪ9���1�~���)��TR�*�yYA=�R�Q`�[���|i���;��:ӭ\yC_�7�#��7x���e�u���en�nYVy���'�e�&���U���W5�F.n���V⳾ޟ���#¢���{$��$-kx�F��lGY"��w�ٖf �vF�`AW��x�M$�s\dY%2�_EfL�N���OF�9���銹Z�Av
��C���Vi�Č���[�ͧdj��3 � ���i���R�������e�ĝ�0]MKp�t�	���A��R�ʵ���/c,����[l3���{��j���sɛ���G�{�ڞ����հ���e�W����C�`��kWE�w�T�u'r�]i�&a{\t�־�^s�k#�5y��L^ȸBqϼ�ۼ�g�;;ƵC�b�g�k�T�n�Q�G�h�l��_k#��Ye�����c!~h�qe���6�TC3��*m׎��ih�c��K�f��˦�^V�������}] ��6=��r�w��n��γ��pa�丨��T�r�
��Yjʨ@)9�b����ų�m�y9�8���5m!0���/���z�ּ�C=KNi=<b�"�
y�{�,#˯a�<�Av�eE��L�I�������|�*���S��cqk^ܐ0?6$Lk�#N��6!#�������{#�%]
K�1T������c�������Q����vY:p�!4�a���&x7e�9=�����:�/L�q����ǧ��w@z���3�2�m��:��l�'�Y+<\,�C@&��O:n�{pE�[�Ԑ>	�.��$^86����,��5D��v����=|<#n����4�5�9`޴����叢3]�S���Fh#��&��I@B܏M ����O߾����e�@n�������	� ����)�.42~��i}��r���-�d��X얜�Pl��xE"�j��F)W)����I�Ќ�\s�"΋��
IYOFgQ(��b\c	*������po����xrd����O��킈@Yyrض���6T��8krу=#�u�|�P����u>	��a���|�G�9��2�"�)����GW`��X��{�� �xLxwOV���D]l��g�	|�O{�+��sz(t�c��.pz���n����^�������F������6��~㠘x"�"2gۚ _�'�Z̻�W����'|���q�g�^��I�@BL;SS��M&�w�wϯXbb�0�md��O�[�!ʌ�b��P�)���H��5 !���,p�C+��,�Q��e���n�}�W�L*�0YŨH��Vg�,n_ƫ�T���Z�$�X�4zDa;�4�ϟLډȸy�$���n�Oe��Ʉvc^�C(z@�ܢfS�vA�1�A�� ��{�_q-v%�S�0(�:�!�w�N�:Hp/��=��=�9o�`p��/6ǚ��7kk���[Ė��'��@X�&r�Mrv7��h��b��I\j��eUD�=�	TN�<~lp`\�Y�c��������]�2`j���b��^t�ܭ��' C��'����V�&�ur�Ȟ�MZ�!�H��"ϵ���TԮ�B��Z�}�����Aꓞ2b�(�	Z {��f������%�����:[�D,�,r�ų���Ζ���$�a�~�����]��Ӓ�����S��z������'���f^S?l&Bw�Cʸ�{?}�v��)0�.��4�^-,�4�Fu�-�G�n�7��1_g��S�l��z�(��bx����Wl;��?��7/����Vc��uX����IJ[���d$���M[�+P����w<��~�s:�<;LrRH~�"W@"T���BL�.վH���jD��[K9���� Wr��R�eQ���ԄTi�(G@स�Z���W�8\�����GA�@V�'���N ��X.��fd�(�|G�n.��,���ci?/���/B�mT��GT� �?w��f��A� y�pC�ܶ'�w$C����L71�R�unU\t�#��x�x�`��LH���Wj3M�gpa�wb�_/��'d��:�z�eOJ�<�K/�����N��2�z4�ZY5Oz�@��y�) ��F"���;R=���/G�o���l"wwI���B�%c�/D�R�H��c6k�7Z��W2�d$�ϧ������#��C *e����Ŭ�:�lb�ڤBOVz+��
a����     ���f�� �ļ�ǆ܆����_
K��B�41������R�4�6[ ������)'�GQ����%�놑pf�|�N�9����W�\���5ڟϧo�U�E�(�pZ����&�C�R�e��lr��Ó#<ڪPO�̖�֭6r[������ϧ��[�s�������j~8��ѣO��ө���2k�$�0���o������h����tS��1�NT��]L#{��	��
X7<��xdqq#��߽��Y�_r롍T"�2@4��o+�U��s�Lج{�
w��w��;��!���"�o_�ש}1{V\���������)����������b�e�'�r8t�R�-��+4�c�o{]m�L�Cgq$0g����VE�$+��� c�o( oU���ǡ�ea���k�7����#��Ձ� ,��b�֟�8B�%�L�������ρ�a�@P�h[����knMUE@��gDU́Ѧ�iub7�7�x���zw@nP���R����l�Yn�bkR�'W����"O�,G�Jx��ӧ�����*�Q�]�����Zw vя���9l�����\�3�*�bo҃���j�����ܮ��!kFg���'H�i^����U����������C���O��bsMI�/�:����=�n�Oֶ�-A>1��>�8��|]~V�������x�����t��[��Ő�
1��$�Q ��,�:)��'���J�d��+�GQL�+&u�,O;W$�S���t�e�m_zKf�4�N[+�[���9�.d"����ZY
����Q�f ҃�h����$�BM���
��c^�?�>�κ/�|t�d6��Ӧ�l���x9\a�q��k����r&�����M�X W��p��9.x>����V�=�d4�K�\97��\��IHً�"����ݚ�Z���s��zwW�+��0�k/��򭗝e� �2���������G�W��i��:���+i�a"6/��t�R`�f]&V ��}�_I�O�����*�-H<�B�Gq�G������Y��깈��C�9�:(�H��sy��l�lm�+��ruP�����M_P���SN�QX�T�Nt^;�u�%c���:���~�c���J3�S�'Kg�FG��0*�2G�м��T��kХ)x��vS
��g�Ɵ� �q�{\�8X��8 �И/c�u���~��C�(M �Y�a]�t��qN1"�-��c�6�v��'q8���`���-b�*���l��6�B)��NSE�J�^���-�����nug��,�`���bKK�43�]���ZvR�����z��yx��(s:���7y�ت�|��rS��s{J�9^7�xaڅe�k��H��]MvDh�޺�)e5�o�StjV�*ũ�C].��1�ކ(�[�f
�h�I������q�R���ѵm�%��D5�Z�����W}��o<Umtq(�QF���i�"�����.�uFY}�[n�u?�rW��1ٳ ��N�"i��KTC=$8�3cg���fI"c�vY�z��8u�cc��Q�l�U�n�Ӗ}���X'.7�m�jft���nX�n��a������2&=�-��¹$}vg_���i]���/�֪�]9���v�]]j�@Ē�Ѐ���F޸x���̠u�ъ�<CP����r�&��$�Q�v�z��r�x�i��)������Ɩf�}o��>>'�H��3��b�ח��X�"{V@P�z��s�����M�} `ø��nw��9U5� %toV��M��L�K1���@�<}ntm���������3��D=!}��)%q/���\(���KE���庑X;�}=�Fa��,��|�W���ȼ~�fD��A%��˧#��v���mq�XK�r�� �4���F�s�njd��-z��>$"�с ��$��XA��I�`�jj��T7]ҜX�j�Uj]$*�y�\1�d�Ƚ�_60�|���/lc��/ ;��B�0 pC�`�X��V���D�i\���ljb�bDri��?�`�g���O�%ߟ_ڲ)P�<�ob]vʢ���lWɇl7��'��\Qg�7���An�/Wm����Z��"�6�� ��aJ�|�$�`s�9ӱ2߸ ����Ų}�1��?�Dw��m�Fӹ�ɗB���{n�l�\���&.kN�u�!��8ou��q7�8g�������I��Z� jSZ�te	�eS"A�OZ�f���x����� >�����S5�����Vq�����y�z5p�b������Q�*`�aӼ����n_�,$�d58�0�zGZ;�d�ª
�݅&������h�[*�n �c�"��F���I�0vM�"BtC��mY:Ζ�����0�����x�5�����."�C��L�Ɣ���I�7q��Ǉ��=�w�ܠ=���娰U��g�p$j�S!�eH�;~�.=��q��1PNq+�i����8��*�
$K��]+�b���#�jH�i_�����o�S�l9v�P��8�DI��Ղ������p���}����i��>���߼>�f�_T��g|#n�#p�R��Juq2Z0w��!��?��Y6/�Β1"�i7s[>B��b�Y�>��x�)�[�c������,�"��5ū�DJ��iq*˘c?�d{��A�pspF�&��k[w�t��b���y]%����/UI��CH ��'�	m1r��y�|��T��Lq� �}d��FI㕑��j9M� �_���E�Ǻi�]�-Q�A!N���ZYE�ʊ�^-��w�6s���I�X�/|�\L����3Zc�Ԭo����=�I�)�V�s��:���>��B�׍��(�B��D^�V�g[����fň]p�_ӛgmp:�1X籐���8�i��兒+}8�/"-��ަ��D�F��"������:�q���χ�χ'�w��В��jU�"'�Λ��X3�s�˘˦��Vj�А�m%�v�<bl0�*8�Hѻ'��ի���{Q���A�Ud>H(��H��3-��k��Z�`�Hhi�u�<"��m�k�-��E���"�[Ǚ1I� PR;�BU��
 J���xF8Iڰ�������+k���Ss��Lb]�9���g��&�V�@�z�L�3k�z�o!4�)�g��}W�p�X{[m�L���ZGb�F��*o�U��Or���Ɔ*�S.Nn>(�����e�Us�kI�h�b�Ә�My�+��H��;G�:j%��� �j�B��2���tE��z��t}�����q�ߟ�.����JG���s-��}�O�_!$��0�`���֖G������B�#���n�N��э�Uo9Tt|o�j^���&�X>��猧 �3�U;��\gVL9��(���8P�<d2ym�Ƭ�w�w�t�'�k����D�P���f.-���Bp&n�@b��oOe�޼�A�UB?���W>��0 �ǹ��Y�V�cz�rCWj��B�U�"� ��׼�2�ە�,������J�m0�4�o������Y;�˅�l�'�/�.U�ʙ&V��w¯1o���/��`l���Ʉ�J�k�F�~��Ǉ��H�W0��>2�ta%����S��b��l�AO%rq]ZY~���8�n��������h��*7T9"_1����c��lۥ����bT=�R�O���p�A�i��; B\�������tU�\fV(��yG�U]#�"*����yV��1�JtX�_��2cX�δb+dFN*�����l!Z�h���d~w
�
4�r�'��*�I�}�ڼP�ƈ1ބ�w�mSY}7�#Y���l�����^��y�=��5,�,���>MNt�0ԣ8�o4��K{Q�40�0~*���`�*����q^����l�d�F�Mvڝ��(��tO=IÓ�#׏z�F+�)�d�6��Lo���('b�#�ha/7OߺֻR�߱�
c�V�h���y�*�.	��[���XŊJW����n����T=M�0�7C�\s��a�E�0G� p  �ݶNkC5���y��=�G��!��������Yg��;=�J���׾o�,�)BQb�n�U<��"�v�7�nni_�c��'�V�`ݸ��x�"�{Ts��Vh�yxpt K�����QÀP ��$��ִ(VA��`@s�9��w� �mb}*�uC�I�D}��
\�˓�!�J.�=����ZmJ+��Ɓ)a5y�#�$_6�����6�}�F��`�9�pr1^N�)��S
.�g36nfk��>�Wf��HA�q]#��S+����yg��d�u����F��jp;Zɓ����O��f��]o�G�YX�4��-���bC$]�-Q��sI�l���|_ػQ��+Í�+�27��@�f��q�h��!!���Y��q�A��m��S1��NWA���.[�2�������4�����q^u�'sO�z6��p�/�^��zw�����@[M�l/�a� hɞe]W��e�s<%>������t�Rni�C$�G���S5B�\Ҫ��_Eԃ�6��r�Q5b��D�	S���ts�y�!L��Ya��������&���e��lF��QBj��I1㏫��C�	�e0�TsH$&'A땓�'b�!��EB��av��,��o&'���-\��P�`{��Ox vu�� F�[�[qp�(\ϝXA�7f��1��B��_>�B�����ND�G2(�LF�xO{/�ru�)�\2\c1<֞C��tvQQ���O�����a�u�G�D�S�Y/�r�H�܅����h�j�Y_��9ۋ�4.%)�َr�T&����~w:��M�aet�`�-�P~-��������բ�a�\-~��|���F��aFmG^I�!@O6���A��E�!n��0�'�U���Dΐ�^�Gg�����4;S�<���Y������#BQD��G?.��$�Y�⻒i:I����{1>E�,?����#��G��얙�����?����i�8��b��?�ZX�y=%�R���^9�|"64��6a���iNi����c�T�'A��j�y#�%��dbJ�"�#i����q���dE��U9,��$���?D�� <�C$�1���l��=@������o��?�|��      �   �  x�M�K��(����L4~{�$ڦA��=�����+KɫJ�����;�9�s�[�\ˋ9vn�~1'���-�9��s�#���j͕�BT֔�s\K��ķm�#�X+ ���5���!vW��-h^�����I��n	��X�{?�EM,撶4r��[j��	���LѢ'���0{�D�%kt2{��u������Q�� '\K��������9��-�j��	ղ�?f���0jV��=%���#	y*y�Gs@Itȳ�怎А�9 "0���G-��1�n�怌��P��������q���!A?�怎�gHl�#�Om΃!�Ϝ��k3G�D?W��:sDLT��^kv�L���3�d��	޵�戗A���9�%��E7i���)aYODR���1ysBRLae�'$9�2'��`N�)5kB��P�r��fb_.�愙ȗ�愔�Ws���KQ����9a$�����3Fb?�g��[�"���{��I(��?1R��h��Š�	��b�*����sFG$�.���	����#��\4l��ݹ #28���؈%W�����|���5����k�.�Nn~������{�L.	*E�����[�n��x�O!:s�K�+Rs�~6W��r�ջb$��=uѮX	�^\q*n�&]Q*����`�K憐P�I���kn���v�*~�M���-�CvCJ�h;�tsCL����ܱ�7��U��&�S7q�biA��!'�=j.���'X�����΂��f��Al��m��0x��|�ʟ*�������q�(�*����{t5�����ƿ��Ћ�̑���=���~���t: �����^5nt��B�Wm�	 ��+��	 
�b��thM���c*XS�X� ��4i�h0����'VKs7�W�FP(?�.`�.��S����m�Y�!(
׶��"fi	�6�4=l{:�J֕.FۣE��3��eA֌�(�nmY�L kQ$� ������bX+���o�A[��i�8��0m�H� �%O�p,%���U�,���R�,-�ě�����{��]{KS!����	���y���w���B��?^,]��7�\�z��17���KźuyN:g�2oX9t�>i	h;�'*���,���s<~�{�I	-���O��`�BZ:��sk��~��fջh>���Vk�>��u�Li@��&*DM���V�`w��
�]��Q︯n����psIˡ6��giGd~>^s�-�z��blyA\���oc��      �      x�3�p����� ��      �   U  x��U�r�0<3_�p=$��t+di$Z����x���GJ��6��$&�X.�J)-6���-`�8!�KUd�RR^�m:C��a���[G��Y�'p������q=È�~5�'؂�x�����A)�~��U��t�.�#cR�X=��]������*/eV2R[���l�3���hA�~R�V���a&��C�D�-v���L��#$��[��c�Vδra��ΐLJgyQ^�Z������WXP0@!�(�5���4�&�%g���3H`٘.E�LeE&e��j�l�ԁɜH�����=�~d'�F��0���pbԖ^b�{�4�*]%�11�����<���p��?X�?�d�{��BV@3-#�%�B1&�j�V��'xgf�ۗ@�M]S�����������_l���f�jܮ4�'PREI.#��n�h�AU(z�֕���RU������o{-V����P1�#W�,�fבֿ���N����}d��dV���|=N�:c���[�0��w,2i��ܛ�xO }�a
�3c��JUΰ��G��?�����b㳲;�Cý�4�e�V�k�r27���yB�3R�c����}?Qt��Ţ���K�*�eYT��gH��"�15m7_�D�,#
�ˬN����1��&��CZ�q_	L +.�ʫ<�/��7�p���.��kv.�Q��
uѹL��lͶ�c����=Y<��_�?R>pX��ݫu��B�݌�)��[�J	�7�x���k����qV<������ui܂mh,���O������"����~z^δ�dy6l��H�,RK�7��#&�}����3��      �   �   x�U��B@  ���S88/6�p,ɬ��M�0��Wb��w��|���P�~���� �EE�9�x�مN�6,P����}{��󪳌��ǆ�˼F�:��;��B�6OTpY��������4/����ĉ� �Flp)g���sٗ��KUp��s��"���~��7�      �   9   x�3�tt����tL����,.)J,�/�2�v�H�KO/�KTp�L,N����� u��      �   �   x�e�M�� �5}
.`�1f�f�����.�?G���E��{��2�Xe�����ʩ����4�~��M�[�FpB]��K�Q"?\-�.�U�Q�Zi�#����N�Dc /����������͇��su������ͨ���z��pry'�SĠ�Q�G�8˖�O�V�i�V@�M,�����})��_/�r'W�s��}�r@�%�*���n�N�' x jKc>      �   x   x�-���0B�X̾�&�^��:3s��Gr9x,�'AK$��Eۖ�Ua�Q ���76�A�]��:�\(�ID����NaN�]=&2��l̼oE}zm�뭟yX?������j\n      �      x������ � �      �      x������ � �      �   �  x�u�Ir�HE��)x��9/iK�R[SHruTD�����PIo����%��AE��q�������?Fם�����ػ��?f-u?�����҅�C�*��m:���ҥ>@�����t�l����5>T����;�	Z����<]��i������&�~���E��M��.�4VE��m����k�{"hdwr�퇟�K{ R@2H��<�"�6�ld��'�.�\�{URO`BQ���n��p�:����ߦOAG�Cɶ�N�sG�e��S�*v��zV:����,�1�0�^5I'�an$�3Ȱ!sɈ`þ���xx���!k�;����]��	'{�:&�p^�T�XQ�^BɁ�u�hX���0�U,F�f��;̽�U#�h\P��6Nِ�b�q�Qr�*���*�m��+*&= �q] ��惬" y�f���b�Bޯ� ��}z�^2g���{��GB���ı��-�ރ�W6lN9�MЄ��/7#��+y&b ��ȩgt�	nU�`�����̕S�
��曉� 0A�8sLh�f�[v4A��y�a�8��d�4����x#��kd�8@4��	��<F�"Ds�]F �z���;'� ��][��@,�b�4�YE H��5|�#��0�$�#gy��$�޶�� �L�����0\I��F �����σ VJm�U�R^����J�6"f`�OlN�����IE�4[f�l٭� ����1Z68T��i�R9�s�<�d��U���n��i/V�\V�JE)�*�T�]�� ^��"���d��u�;>L@%�j�� P�*�X. T��E���/�S�4�+ SJ���+���e>	�����ێb�F�5[~O��t�Ĩs{�2���;@5�r�9����L��P�d[��&4F􈶇/AUx�m�7_�S�n4f4ɯM������XТ�￦��}�a��F��a�ۍ�Kt�$���َ�4VR���%xk"ת�����8)�j�� Gъ�i��g	gM��f�2�ߨ�EeE\����IJ��&���b�a��'o��N�,İ�ľ�Z�&mO�Nl8و��&6���8/�כ�`��K;DUa��`���m:��Po&ip��t�s\��'�Z]�y�nv���vG	t\p�W�rr
�Q���]���vx6 H� �$Xsr��])Ú�+��)Za�ɯ?�wN��Q�/�]ϗ�ϰ�ݤFg�.��J�q-���W�.��7̂�6�||��?_��Sǒ������.W��׵��N�P���{��;y�Φ#�;�q1��@�]=T��i��;I����_��)x+�O!,Z�� ��]�� �YHV|a?O!�&��2\�7�̂a�u��A`�)��F���iv�~�&����=����4��G���B��B�/�ZT4W��������`@1F����������bj������Yn�\x��(h.�Ҥ�6�D+�?GG�@s��&x��� ��Ռ/�7**J����T
��b����7�~Qi
������?�``PKJ��W��p���v_�	�D���� 5e�c�2۾�BE�@٭]���[���3�(�V��C�@Y�-�a
��7*��ܪuI �K+��A�@ŀ�z���z�N�b8�C�@�Y��Q)P�vA���� j*����T�񉦮�J�f=@T����*��A<�ߨ�Sy�􌂁����6���'�j��P�vhUA����pEi�$��"EHʊa�+dFe�c�Z-�j�)[���b��Ҋ�� �r��)�`"�>��`╞2)J &ר��(��m���) �L3� &�ț\gL������~�a�L����t�ȋ.!�r�� �ߣ�*2��+�%��`6���k��"`�A�FE��VTYJfo����g-�5s���P0�M�FU�l�i�1���.�n��X�nV� � ���'�� `G� ��Q ����$����YLG@r
ɍfN0�-��n�k����G}y���g���T`�=P�����0�<�7��ϳ�����y��A?���e�k���g]?{��
b����Ps�����]V�|�z�0ˆa�٧vј�|�F,o`� ���0Z�~���w���#�o�      �   Q  x�M�K��(�׋�c�����::#�\=y���R"�������}Ư����g��_yV����?��<�ɟG�����z���6�_�O����xJ��:A��Kj�?�>e���t�r�S���k��~��?E�HW��|�{�:�ro��\l緞*C���T���wLx�0��WW�tז�Uv0�u�k�`�Ȋ��4eY�^S�����ri�*�g,�d�ڲ�i�Bƅ�w�y�3�.F��գ���]V���J�ԡ����#�w�y�^����qh��9T.��Zm14/M�&��O�K��F �j�EM�
�z: c���L�;2�w��G��Pޗٍy�hBc���!C6#��|ƹċ��8�#}�U�ifoZ8����v(3y>�a �Z_��3�%2��
)1y s�GY�B<�\�ͫ^�7䉁W>J�K�Z>�:C�*�1J�����&En�9I"WPȚ�ğ$�C�4r�Q6�V}O��y�EX�ͣ |��^-��(�o�
� lS�ȞGaә������9OQ�@T��Za�L3(���
�D��d��kx��`"��CLf�YKR�)�1ՠN�GAŪ����7%T�)��p	�u����}��%`F�\%b�B�=��<��~eL��^����Ԕ4*jȧ��M�M`Ȩb��ƽ2��U� �����;A�!|�H�aL1�dl[)S�
�2� �IP1�KD�d�(R���.yҊ���+�%�N�}���靧][�퇅G'�맰�e�<A��P���$T�NA1�[�6=n�N�,�P�OA4=VM�(!1Y)�l�X,4T����gǾ���(vV-GP1�K�Z��3U
��/���V�l��u���:V�}����>�2��4��s_��[���W�����Ō�Jn��>^�{�l0m�O6�l��\��Vo��&�X����䵾��d^uz�ɖ�yW&�J������<[��ʬ�xʸ��ɬ ��	������M��6^:�S&�!��Q�?Ma���x�ĕ��}V�{�2�����ղ�21(��i���y�O�j^VLO�����[-:�"F���w�Ǡ̑��kqЫ�صyզL `Uj������%P�1˵���̭�B��M2W5ʎǌ�(kճ��i�N�JS
��U%U"U�
�<���%����4M��2�K�����"�l��uIP���[�*���ν����� �B�d;��A�S�d;W쁼W ��`u�P%�A~��-��s�*�t�c.u�{���%�Tv� /���ie��]p	)����􃦱cH[A��@�0�������v,����C��$�*�X�-��=��)�8|�L�Y}%:�zZ�¡���٪�Vu[5�*�'N�,Z��m�H�\=ԑfu��H��Cp�Y��4�۬�fu��:�,�ra�5\4U����*��m����a+�0ֽ�-����q/f�<LTBD1��8A686c/��`���إxlݥOe+������Lo�I�;�ذ��z����iXؤ��l���<9�S;S����^-b7��ʶ��e_1F���ƽ3/�o�Z��hg���?�:i���NIt@�Ϫ��)V�jZM�]��8m�#G�q^\���@;��"��v'dj���c1iۅ���khy���X�>�h(-��D�b�k����Tq�J��4z��ua|b���L��֚��|B`���!�� s��X�@�q<F=��cA8�˘�K�����w�a�>�s�
��9~�7-����c��k��8m:h�jZ劢մ�%Eki�+��Ҫ��XE/�u|��
�w!ѐQc8�,�Q��o_*�F�s�nV�F�3J��D�!�q1i/�Y�WB��q��҂#��ƶ�����Y�hk�\�o("�z����@�U�>�o#zKz:j�A�Vc'���`]�H�J	�bC�9�����B����&HÞ�� P�)��"������O�3�]�МF�B��LT&x����k�,�9���2�N�����H:Z%qk�6��c�]�4�;�=4,�]4���Bs}��f�	���1�A���������~����v>Rh�#��0H-nƮm)�C~�$Wck�B���bF��e�l4��lG�Tw��t3�]hg��^
2�փsO8���}�ӕ�6��i�����ڻS�*����;YIs�V����@�aO�F��*ԋ�5�����#���\�Yx�$:���~���z�����ԏ$��x�s"^�w@����q&.�
�V"���-<�D�xPX�=h}0j����FtĞ�C8m5b��B��;�훢{����$�&Г@��)F��*�&�H;jO��zoc�H7U��2�\`e�$%�"�����g���ܟ���<Q�0eb��ڤg!��$kG�}3�8�=���
G��3����x���F��IHw�RrG����XD�ݵ�d�Y>:!�A�$��V��eTvQ���.��@��nvV(���Nnn���>;�O���ח�x:����ɧ�bI�D���A�����*;�{��S�d���ǰc�2<|>��{9��v?�v�c���9�i`_��\a���<�Z��D^�XK>Z|����wI���̟�:�[��5"b����f��6�Ʌ����;A>w����x��\��׻�(~�{�Q��n��j�B�#��T'Z��o�#���N���a����;��@7f:��W����3��/�؆���ؽ_V�O��d{`|��I��\�p%��{��=9�G!����O�:�}�;��%����H�~�2��mĪ#V).�����ee�o����VcM���~<��@��"T?.�Og3q�ޕ�)����{���;��h����ˈ�Ǉ`�?x�xK�������f��s�}a 9 �鷭�����{�&��څ�xY��<���OB���ot�g�fq�W��b��8��+�E�.���$r�}�o�����H3<�ڝ�e�jRh?�?�.��Zh���͙h���+����o>���&;�P�@Oz�DOz�]=Vz�a.��L���$L��\3�N��v��W�v/�J�FH�D��m�@���tl��t,�/
{�M`t��9��>?-LvM�����6��e��E��{�3\b�O~ ev�j�ᝇ��V�ZW���=�5���)��"p�Dς�<5vT��$�z�4���Kr�q��8F�c����4<>Gco�{��Ƒ���|��b̻?5Pܝ��<'0ڽQ���𱫬��F诓�����=t�I��ux���j�]�d-39g�,�e�x2�'е�3	ʯ�`꾋�G���-9����r����Eq�e�՜�]y���v�N��%gŮ�g7� h����D�� п��^�>tO4���m�U��u�ԙ�Ch`7b���LVyV�Jys>��I7͛=\��_N���w�)������QK��_K�@
ͺ�D�^�ށ�	�rf~�z�Ә�h��ü�M\�9���oGA��-�቞����
��Oqӿ_��b#�'rF�iR�Ҷs%&;�3��Ca'�r�`,�ʩ�:�{Ws�Λ��R�N~�B�E�p$�a�!�s�E_kďV�AK��j.vO���e�m-y1��-שL&lE�����!i���s�Pv�wn�N4#~�_��P��^��=G�]���Aq"	f�l=��qs�Y�&�
_����2
a�4����3yJw����j����D�:^9^ƽ��[mF'8�F�8�~zS.�5q[�}����?�_��A��K�J��;�K�ϟ��?�M�KF�����i�ך�(��	��ܓ)/�O�,|x٧�D9*C\����Y�����ߺ��Z� ݧ�x����.n�y1Vn�-Č��(�}"6���=+����<��^      �   s  x�m�=oA����_��z�C2�$dd�	��5�ƁuR٫�g�o+^���x�+����Ǘo?z���I%�N�4���I'�N����d��$�N�,��d݉�g������G"�#eDfP24��w^^��r�m8�q��,���)�����_�{�+��?�38d%��=�R�GlIx�="���G$Up.��"�*8�9t���b���b��<5�FX#R#�k<?�G,ps����Q�Qr�G�9�-��Ry��(�Qr8Js���%G��G�Q�(�Qr8�r����Q/Gy8*UyY*�^��F-��joDE�ZC�QѨ�PjT4�5��j�JE�Zë��h��44�N�ޢ�F�5ʶ*�V�FC�5G�~h�<��1X�`^��`݃E����1X�����`݃�dw��'�3Xo�����%��8x��_�>��>yd4�r�s4�u��r��y�1����@cXë2���>4�5��a��@cX��0���>4�5��i��Dc��17���h�r�ИۡOÉ��}N4f?l�Dc�S�Ɯ��h��~���
4�5�.Zh,kx�+Nk�
H��ƪ���NDc�������_����4ܗ�X�F>��ƺ5�_���ߙ�r\"���,�����
Y�l+hW%������N'DW'�/]�l�uM��{ٮ�����%S��v��L�.^^Q3%�x{%\��x���3�4�M�}�KVͺm���ʪY�=US�Kl%�SF�T�e{F�M�]���n*��e}SQ�.ao�h�
�l�ʩ��v^�
�l�ҩ�\�I�Tl.��u��ŭS�Ne�l[��S�;��
�SY<���S�<�g�d�l�[XtOe�l�kX�Oe�ܳ��_�a�6      �      x��][%)
��^̄oe�� f�5g"�ntѦzy���?9��'��a��!��J��Y���ǟ��/c��,��?�+L6�"[?ZO���$*���� ����MHM���n�����'U
��Ր��j6����R+���Py�T�l� +�d��F�j��Q��E&+}��O��5���J�d�=�GCx�\~���+���ZȆY?2�"d�;/���U�9x�bH������"'[�����h����jv�1�������O5��"j�kG�P��9���lG�s����`�	Y�Ik����Q�'�����g0�ڲ�q��p�U��TBT�s�e'�I���k�%������@��O�e΢�$��pB~`��%�A�ad�c��Dr�R9�� ,5� �Y��B��U��f�U�1��/�Ԅ=�  ��:��#��r��pk�֏B=c4� �"'� z��[���ZY7.��#Z�L� d�y����z����Z9.6%+�F�'q��*p��yv״mC0��DrlJ�W@�+`	��׈&6�"Ϣ*�$!�x�=�W�2��F_s��υ�b���(������%D4�����Y��Fj���Fޯ '��%�֏yE`jUn�P�\d��WT��I��^Y�9EvTiC5ƿHMY���q��X�Y�4:��R�Ժ�yjŸc��`.0��Ӟx�H)�W��	�<��)pq+���>)#(���cɵ-��+���B)P�!W��d�5����.�m�_��Vqx�y��2}k8x�>� H��(��d?�۲�l!��4;��G��*�fYE7 ��L9&�DQ(���&/�`��] i�O�}�~�%����*!�� Ȟ�(�_v��s�(?��,9d]�v���!��Fo-C�c���</��N��Q�F����<lJT�3"F[���,i��$J�sg��S3���r��h��`�_%���Ƣ�=ik��B&@�x��� ��0E����hˬ������֭3 ��[gVn���K�(�;ϳ��[F�)d|�ה�,)��m(���+�c�e&k�.�v�h����B ��
��e,=��h�q,�d?�VNsc,���F\�	u�l�%�T���UV��dCT����>�Jͼ��a�"�Q�������� ���k�����ڇ���:�br^�r�J!ZO(2�(�"�p�r�����10
��(����o�9�����l�B+�!;�^�H��	�����Wp��5b���� ��.���ڪ�U�Q�����c̲uQ�y�bU�,8���m��y
l��h��u���`	�v�_�XgEf��8���M�fJYIE�wu�y~�������=:�2ʉI�^�4钰n9�ԉ�+0b�<��O� �G[�V��I%����c�����Mo�'h�Q0x��(����m@��.��r��y�&8�Jir���Tʩ���"�.����X<v����i���/2ǥ+�Ÿcj�󚍢����ُ%�']a:���{a-ڄƼ)�3��aq��X�Ϥ�B��j�'ꍋ,�ⵒ�X�{��i\������_a�.��϶gX�$�=�s��,C��o0����T)ع,��7��Z���t�pXi������m��|���a�����E6���'�ܠ�����f�mZصW	Vf~��2|���=��-����+]��ĞXSߜ�DY�bz�C��c-���\��c$Vd�Uu�ۋ+L������Э�<�j�����O%��Z��!�7����y�L�h���k޼��)��6kҮe,�l���&`�.��]�&�&]Њ�Yc�ǯJ��������
�,�n��\"�q��j��2�j�Y�خt`!7���[�4�k���]$T�<�����a��3Ίw�vȨ�_m�>H��.S����+�woX������ϻ�W������vp�A�y��#@L~�R��PC���M=�X	|����r����(���|4_����f�t�9�^��J��4��Ѓj�H��t�����wZ[w�4��������x�m�]�l6�l�Q�iq*y�Q��ٟ��K&a�5��k��˲%��d���5�l%-LZ �~1+꾏�$5�m��`b�jD��Q��!�!�H������B|i4�pw��p����W;��9#J\&��ۆgo1)i��ޜ4q)��)��z��xN�����`��|�K�q�
2$G��س�d� A^��L ��y
`\�����&� o��ɦ���q��1wN�#�?۾��Ǌa[��)�btIv��9�&��A@$���=ِ�G�b=/cd���C����l���0J#Hx�	�~&Ygs6�Ǿ�l^�[���\3l�X�q�n��7�.�ĳq�Q t޽�R��$�h�<�P��i�:	g��ϭ�x9��Ƥ���؛$+	��uD�pF�]�ccO��2� �荎
�^"�o81̹��^�A�}Y[����OMm�0����*�V��#h���d������]x��:�������yCC�9�s�-��ۋ������k|1>���В0�2����)?��P���.잩$����SfB���<޽f��!ƤT�O���6^�b��Ȇygu�F��R{&M�;� Sw�5�p�g~���|`�i���\ld"�.�i��'C�#	!�[��R���V�,t�u�orq�LO��/�L��/��dH/�8Q�s3[R��0��eS�f:?��=A���1 Sz�% ��gJ`�&���ފN+�c	�l��q�gZC��`���eW�i�Z�y~�����M��`����U���j��I�HM�$J���v_��N�_�8��ED"�����/���������=��ţ�[�?4u%�я��;�d�)L�
�H$���&���G�/�Ɏ�%s��,n��p����d�����h��4��1�r��%ZJ��d-���:�I�ge�d�(81̿ve�X~vpTL�%���D^�Qβ2-gה�r�@������=�o�c�c 7����T��!^������)��E�W�@8B���r���*�$ΩspI�i��[�qom�e��4ǅИ&�����D7���~0o�d�-�6-�aq��@�oi�Y���B�0{����"VB/*|_tIVR^�5+�10��/ΐ��c $p������M+m3( eI�{*9 Q�ٲ%�ս`@�ؐS��V����͡:�3����(p�h�C���^�yE�".�:G���!�� W�J�-��/�7
�P$I&?�","� �\������4Chq�"���pٟ��u�&)ɉ���}�Qcx���I�y��}��8yr��쟖]�k��g��I8��%���|��� �IrbP$i2>�&�,i2'��֐�!Ki"��*��%����\H/�/DY���,��*�9' Lg��xY�L�{���}��NX�劥��[d�	�S&Wi�u'�����K��b�X"��flט���.��T�	�6o1[�c�v�'Bi�Ya��йe�2��:��8�,1�m�UL�%Ql9�si�{IOS�A�f9�H�2����A�
�c�ml����!�ʬa�NW��[_�� �U��Z���q|0��2
%�"�oޜ���(DDTg�]p��+=�qWe g��7�{�2�h����\��<P�O�7���v��M�Ma�΃���2��??ɄN+�<S�x[L)��Q)ۄ%8꛶����5�	''�us9P���1I�x�rW@<U>�����i�>����Ia��Җ����+?<w�Nn6���wr㽇�9��("�Ʊ_V��{~tl���^��Tj��b�e�>�/P��.R��)�,x$"1�P��G�ƺ�6���Z�&׀��K�}6�"��ٝ,阛m�p)Y���d���j&A�O�ȴ�qRe3%��ˍ�I�II����#K������A�X��L �&l��cўK>�����k����� �1l�����(N��Lm�lYLuX	�2�:�;zU�`�R�~�ɰ�X_~\h��3���^�����9�����2O�)���ʔ��L�C�[��L��sB�<-�M�)�%�QYF��A{Hc��=�p������

�y    �1?�c��,jR6Pz±pP/z��]༳��Fsa��[t��"����v�^P���p݃2��s����B>!7����0�.��X�%5춰��}��,&�e��S@d��4t�s�`ؘ�tK��}�E#�δ,�V8���b�x>��J2���\��p��(���9�qY���.��sb�:J^��X�%� ���$����]��ĒIW�^f�$I	�'}���\���.^�E)��%UJQ��ɥ��R�4�;�<(� (y��j,h)@%�sP��^��K��e���.����Fs+ױ�'� u��S6*�p��
qSNK��Jt�Y�T`%��՟�P��N���x�i�YU�p���*�8U�) )���v�5�BT���Ӝ�)�x>��2&���1N��EeܷE'�*�N;\���dM���zJ�X����_����uB/��Iσ��<s��������w��/�؞��U�㍖ث.^h���.)NN8��Y�f����ė�{*ߝ��l��d�{�D��I$"ݨAl䧋<��F�$$�oM��^�,�]��#�LX�>vP�0��Ò��ݼ��J��t#�P��_w�JI.���ve(,nFT!�ŋP���UG�$��y��|E�&��}�lpRp~9�� %���e��%M�P���$LRp\iK 'I�'��=���+�L�:�
�8��s��UY�.V'��jb��YN�I���$a[hv��8ڮ����&�������vRqd%:nK��8Ǒ�5(8�:Q�Х��3�?��M ,Y��\������d��������]טt��X"`���r'�A��d�%L��'�ƪ�Jw5¦��qZJ���W��%.�/!��VY��x�f�E����Z�����j;$��2�iX��a�d�n��Y�ʘ���b�Շ+��/Cz�K�h�#���V��Y�t��s������a��t;�Z4rb��s�E���+%��������]8^cN��7^�ȩ�8�����@�v��J����ӣ��b���=�
hX/M�iW�r~��cjo�G�A碄���y�C���*E�i٥`����K���u ��s�tF֐�o��f�k��%�a�*���ҲU��'r�t��YGΚ�q���S�e����9yc~;�"�N�+�(�V+Ν��(�!�2�In�pT�6��-	�|DN�n�����QW	�6������#�QC�9c�DjaN�d��I�!������k����a����	�)Gt�M����`"j�,���,#gSC(	���ǯ�X���N�㜲�n҄"��em�ZM-{�-J�I��0X�X�6���`+&��$��)eLY�1��$g���jѳ|�Ir�$���1Ս+4rjY�����eYU����x"�gd��TᑄH���k9Ɍ�(�>��9�,���+k�8N5��<�������w��-97!'�崘�W.�a�3��ߏ�s��й����Yg���Dg�kSJ�)���^��yg���V���݀e�x�1��\�|����FN?�����#'����B-��g�F�D�_�^����|�WS���oN�Yϻ�e�����c��v�V��"��&'���ݥKTv��G?���G��;�,��|�"հ�Ӡ^Ģ����B��w����?A+��@Vd<	�]Yk��k^P���Y3?����EO��:h�8�-�ǵ��R���-**����+ע��F>���"L�
6r�#s§�F���`����K�MiE_�n�bA^�Z����f�E=CP������y`����/%�E�1Q�>���X���^k���bG�l	xz�eKY���lIr�-Ue ��o�!y��2�R��|
r�X!skJ�-WY����'z��K�y-�Z��ZVɇ������s^�8Y0-C��r>bq�P�d񷓭5�j�){9�x�]O�G�N��>�T��p֢����?�X��R�g�����\�ډa��Y,��z[��=k��ρ�� �-�ڤ4�h'���Ȼ���d����9˾[�q]�����kckA�w�����):�G��ڄ���:}נ#:�t��ʼ<^T7[K*n��V?�Uf��V��ύ9������s�'ˣU����U�F����L]�H/�m��x�yT�&j��6�o���S�Z�5{�Zh�eEz�Z�q����)ˈO�ܓ�l (JE_~�&�_k�b4��j�b�����UB�mm�2B~��im@�xͦ[S
�|[SFË�!�|]�C������d���/�DL����������v@Ӵ���qci�f@���h�cs������m}�6'����'m,w3V���oBk(y>�6�B���{i��@��!�`=���	�}B���^nv�n��⋼�{��5"��0�����R�~�z���F*��YQ�F�c|�����[Yau��p �ڤ�B8d�-��~Q����o4�}�ܮbcg������+k�����@i���IС��h(K�E�t8T$�Kx��6 �p�Nz(��F<=T����Cӝv�{�z>���)~΁\�K=��cƀw�=
4Sԕ7#4����^�c��;�=7��#�q{�����:�A���N/�B�O�a�A�)�R���܅�j/{Z�8�)=-�q�͒K�=K�������� ��M�SUZ�ߓ�1ϡؓ��^=�i�pk���%KE�o�O;ue=uȬ0��a'"+�x���$��c��M��"��.���\=�^��N��E7]�eu-v�2Y��f�s�V)�Z�*��zhI�{8�@Ez i���p�26�������I=6��E�gg!2��vgl�O�u����l���L�l���qg�\��;���Q+B����pmw\���^�b(��zQ�~p��&%�R5?I`��%qA��x�y�߼xf�W�W�j���^{\2^Lyϑ�U`q����9~��"eէ|+1a)�ff~r�_7�$,��}|,h*� ,����Ž�k���{,�/��֔���#3a&-X����ף��QlC���}�t˝R���1�R~R�Lm��F�N!�fR�C�%)�8(<�c<���w�#���hB���pzo��(��N���9��G���K������a��	3>�B(�ߤ$Ð�MK��w�M����>ݹ�:���8�m����m~m�qt+nA�2]� �x��;����A�������2	:x�탦u��"�*�o�"���(2��S��y#譔q$�'v;	.~^s'�%�[��ؕ��8%ُ���|�L,�m��ࢷ���kR&!(ʎ�%}�"�4�q[p����E/GPvq��*��\FX�8քX�
��AP�Z�v�:��op�W� O���¦e���.F����Gwl��K���#�Y����Ǝ�Ȉ�-��L]3�x	0#*(��7��W�0"P�eo��T��Y'g�esF�؇3h����g����/%c�*�>'�����`0��Kb�����5+�3���p���7����U�Vo���·��������і����5Y���t%��h�Xf����?V~���G���<;Y@�+7�'�ho�z�6(~Z�Ȃʴ�˟㻋_*�M�F
�'k2 q�Q6��	x� t"]�$z��Q�+_(w�M�7�F�zn���Q �`���[}ګ��(�c�WcX��A{�ڠ è�����W=j���ܧU��+1�"s�i��.��Zu�ߥ̣���v�:'�;�.<�|T��i_0���Y-��Y���M�Xp}r\��3�OR�{ZQ����l_�D*�]�5X�5gv�q�P�0L?"/,��H���MRiP�b$�R���ݢ��=a~^�������(]q�+]]����M�,��C��7e��(�3�1:)�W���t��1"���l�����W��uM4���4�HO�z^���3�T��P\\d(����x�}��ӯ(�C��x����z�ŷ)�=�II#���vo�P"eW���	ܒ��6��B���,��MǄ�L�3����$��Hi�wn�i	���a��u��Q�K<�� �tb-$]`8G�/k�    �_�ު%���x�
#���bt[W" H4��(��W����xy/��-輹SƢ"�����`q�.���R!EŅK|��6�(=c��^���MQ`)H�;����r�V��3;ġ�@|��ǯ��n���0^l!;�Q����(*Ϩ�����镅���N�0�M?^6Y�J�ȡh\�%�f�������(U]�W�>��?ojJcI	U]��~�n�[���LI��QVf�����N�!IA�o�PV@�'M(C�����+뀲"g�o5����L�Sm�	�B&���vQ^׋���|B֕�)C�����)]t��^���ɳ�G�*����N+_��.E7�3r�/����"�Cl��8���͕�nA�a�b+?/����ME�]�0&6��P*�}�Y�hK[��E���$�u�.���&6��E�ub?s�p=o����r��F���T־G]�82�**N�'U�Yz��	0)k߄��f�'͝�t�jK.��{~,j��ڃ����L|� ���5�Li/����6�c�������8����hz�7��Q�+��ղ��2Ҷ�hS/�����&��5nB4u�2��ud^���8{z_����헒q��@���
���By����i�d,�Yz�7u�*刭��G�gm��[fL�,�9WĦ?*	Me����V���/�g��H��>l��{���/\����NiJ=����i $���(`���9Qķ=g6�`���¯D��c��|e���x)��ď���|z0���i�tx3iyq���B㕏V�"�E���x@X^�i��x��$4��WcM#�B��8�����9��IY���`J�v>�$n���N��yi��R0�h���0%^���^{>�+�/�]���J�;����t�6r�B�o�E�I����#G�
�w�� �^��T�E���"�T�R�׸J����4+	���6�э�z���^��&e���g����0c5�oqRL�+����n׉����MېI���[�K�Ͽ̕���Q�.�)��!|����dȀ�k���ja�IF=��R�N6+Rց]Ra�k��G��	����ѿ6a(�����0d�
���i�>w]�d�R\/�t"�%R�(m����`L���l���[c���G*�)�IJ��E_\�]���I|�"��rd��RA�ّ[���<��83e��@"�'q������U6�O�&���_�"���
h*�lc��T�j�>JU�<"_�k���O��ny�xP*��
Gm�^Þ(��p�3����X��t^c5���n�ayA������3��Q�v��k��7��['%�i��)�g�c�b�˺[²À��J_�����[��I�d��B��9�jw!{��@z(e;M�ؔx`U��P����IH�}/�Ģ�	��$� s��I��8��+;���v;��<�Ƅ�w�ud9�;�w�4|�-����?�t6�w�3�U�0,ͅD�pnn�N��g#�0�Dn!r�)i����'�q=��u�/ש�}�\�m ��L���s ��tt�����R�X!����8ס$30H���\�ߜA�v{L�ۂ���������!���שn�%U�ǆ���n����/�g��8:A������l��N�S�z�AQ�O�H=7�1;�R_
o�F�aI6�mL-�_���d��c�{l#��Gvt8�˾@#mZ�Б��O��S�b�ܰ�N��<F�Y&���q�w1Dy���t�҅�_��G~+X�,o��q��Ϩ���n��e��yՎ��L�,#�t(��Cϒ'\�e>��D|8CC�����s�>tB��¤R�v,,ڃ$�zO=WF\��G^;����1��%9GtΤm����y�۵�LN%L���[���/�#�{eL�礔IMJLz���]�r:=��}���h/i;cS&c�u�I��3Nw@�S\��:�^�������������6�v3Ev�?��"�OÏ�F~�&ݔ�sTB��j}V���M����Wځ.��.�Ȏ�qu]��`��'���À'�����E�)1��Q{�D�������Z���;����ݬc!,�}M#֠��r�J_~8�FL����E�(Og�+\�����H����OG�z֥�����jӯ;)��R�'��Y_U���8S��vx�di��y�P��⡹����t�=aRFPz��I�p�����B��῎4i@�m� _�k
�M[d�����������K��|�@�lY)�~)K�2x��8�#�*~�͆����:\��cQM���^L}���c_��A�b��R0��]v�E��I����kA���mFQ��*�#?����g�D��=�Uv Ѝ2��.��\���9�((���ށ��#�ϱ9~L7z�h�8>��E+@���.�5	6 ��p�&�ۂa1&)J��A��/F(]hT�ԅ�m��/E&3�O!q�|���GRf�e=u=vN�WX�x�F�R9�k�w��?�"��tn��K������&F�}<�E�t+=h���}�-@�ɍ{lեy�Q�Ҿ�<��hS���_|���Efm�.b�1�χ��/^q��f�U)���
��ܛ<���z���Vh���O�/q��iQ�`N�Q�Mw��1E Te��d�&E�:��� �W��P�}|fh�\r5+n���Q��);�	,$����f���={,�%��Ṧ�+�+�w1��8��R	�S�����L�RS���J���0��A���vqi��\Z�DW@1���۞j�
�x|�j��)�୸I�����Y�F�A���I�uL�4u�rB��)�����Mt�3��%�tG�gK�A�(��ߣ�a�x�&MeӴ��k��&\�x�c"�'����y��$�$��oc�׋b��%�X�SDhj
�*��a]^"EI:^��%.�K�N�[{��tP�~�A�ՓrP�\�8��G�ʟ���(Ny#�U��\Ԭ�f��>��X�r_.�L����\E�ԕ���?Y��z�=����,u�a��\�s���!,!vS,Y1fJ?�#@��?x\X��eV	��c�E����Y^߹	��>��*��ŉ�_�b&�r���Q9IZ�l�4��x
����\-s��O���žޜJ�$��5検�>�� �.ާKE�<nX����U}���$�ˑ�_��I�:T6�S�B,w��i��N����e�X)�IW�����#۫���4	�(u,	 7y/I7��!��P�KҦz�����W"7�Q���>f��.Xe�Nw��t`�gv�G$݇�&eƘ/];������U�j� ʍ�厷
��|e�B{9��å���w�B���g=��L�<���7O"��O\8[�>z��#���vJ����P����s�t�a�C�t8yT��S=?)��|5g,Fr�! ]�7�)��"c��]\�u@��'����pm��k7a�/Zփ�Mi�$- u�t2+�\(1���`銙��|�Hp�v�"dփ�E�II�&���S.k�W&�!k��U��8���8[	Y����Ra��r��ImS�+/w����a'-��[:Q� U��(�R٨u������E��3�J��Ҩ� ,��+�p+Q����J���R����>q]�%*G��]� 
����G�¹�,��]��әjR'_s-Q��{�$@�;2m�`�o�#�1zY���%%�$'"X� �vX���%��$��W��Al卓��%�<tIC���P,IJ�h�W{�X�y����B�F��NϏI����6�v�LfKٯE7����c��C*���&�R��r��V��b��ZG�8��uW&�����F���ˍc������E��I��T�o��	�����VM{����6 *R��lo��Ž_ ���[
�)]��RA(����mN3��ٓaі=po�@q���}/��*@q���rY�S�g��������;zI�8���i�c
Ew��(��R��;rMʦ��<��	Y<�6��M����J�\(-[��$8���o�έ5��st�����,-��\�4 ���+p6#��'�1���VޟQ^�bW{/Uz	
Z �KAD.��7���N2���Õr��G=��FՓ~����F�     t��p	8��Pz�[���C9�/���uy��+:ރV�ߴ����Wb��^�'�J�)���`{R�|�n�����e�7	;�F9��L�o����r�ۏ��d�B��ٹP��'�����\�A��:�k����b�W\�.�0�Wxd,��W����������Y-Ya���l@@t��P�뉐��z�1���B�Bэ�J
���� |�Ԍ��������W#迲�[[���� |\c��ǍqհX�]����?^����/kl�M�Ι��v��x|��F��MQ�Q�q�k����(a��VmNپ(y�������3e���s�{~Peu��ϤLIn�å���_�e���g�ܐ�
�i�l�����*�	��TʹvhM��F~ɤ�2�������s��uE������D�45�5MeoB��d;)98��5��2�։S:�m߄�*�v��Or�>�����~�aRU|xJ�sxl$�k7�
�0s���Lh|�^�B��+;xLA�id�����Z�.��&����;6�ȿ� ��xyG�gk)��n�w-�����i����6#XfM-@v��_̭"�,���}�d���,����$�6%`b��	ж	�1�=\��VpQ,h!k�W�SN��YbvH�r��	UkSqu�
��~�&*g���}���0�������9◵��٭o�2�ٹ���N�%�x�����9�DLBA�.�Ux	r>>$���^���
�B�o��M9�RxIt1�ؔ����=
�L5�!�2��X�2v*����Yǖ6St6%NB�)��~�;Ǽ�s�_�=�.��"����| ��[��U#�/9�aSv�l�1��(\o�����Ŕ��~�>�߬�!�K�zZd�!8���o�#����{���czI�u #?���"�������qt��/�Ya* ]��A8v��Lig�W�.�	����V%���VR���="�R/RV���=�A��]r���|�5>H1z��k9p�$���	ւ��^�-  ��ԙD%M�G�o�m���g '�����Bѥ|<�>�.^�D�K9�d˼_e�5���-ﯫ�#�5���f��o��ҭ��n�-"������uL�������Y7mc�sɏ�;%�qc�7v.����ga��O��	�_�jª������"hIX�k�7yU�m�t�"�Eu�����&�_\z��<`p�zӒB�g_4�vx�bܤ��E�q�&8���v�z�40�[��h���-�j:�
�/����鵪h��zsk�)b1qK����L�8ɫ�i�p��(���NQ\@����%�)�W�4�f�V��"]�����|�+�^J����M,���5�I%�\8q[�z�y���S�Ц�� '�ي��kQ#�%����!`�t>�j�^��!'�*��ì�&E�%�=��(�|7�i�X ��G;��o�ر@FG%{�"v,ЍJ�%���n��k�n���]te	5v-Xc�S��M�=W= ��u�;���ZH�%�M�j���r[kXϷ��<n�gk�Ǘ�H���zН��T�}.�<�9MG��m@7�z@��ޫ��s�sj�'x<��ˬk]@r����<��Iφw���!E\�7�G�ȵ��H8����?��#?;�( ��ֵ�V'1�q}(m@¹�MJe!��G
����X(侎�>�Kt�H��E^%F���yn*nѬF�ȿ�H1K�x`c�F
�g�	���G��צbn	L�s<�A��'=i3��[!mn�V# S���xٜ�%u͟o�M:0�*0?�`
L�]ޭ������J��|tꡀ�u~1 |T��6��_^۹bN\�V�[��T��]�k��@�*/�d2�� q��!P0Vr{�Q/�=+Г�t�(�@�v�X�Un5p�Ug����)��]�{�:Kϳ���n��uJ����=rՄ����J���,�.�5�h�]^�g�X�����bt࢑�Ɲ=ߝۓ��]�=)<��;ys��Xȵ�{Z�x������9u������eۮ�.u{���3�y�l=�_�P�r�� �c��r���d؂3w�,g�%oJ�ևs��A���5�^��/7����{S�=����%i�u/@���d�t���?�)��]��y�Ҕ3<��>�z`�lc���b彐�7l[���+��M���J/�W.��l,��������Z���ɮ�ZuL�ĩ��y��}��q�ǭv��A��NU��t?G���U�U�y'�����.�ۿ�$�˭(?^��j��@3�{S�\�Yo[�g�x�E�b�T�Z�[?oX|.�gJB�uIC��}i����M�{#=%�u݃�_��M�8�P�h��{�	�M��aK��Q����ށ��d�U-x�|��񱨦���轿�0�ys6��t���{ʗx�~�c�������&��nֵ9��P��&���1Q��`E7�+��ǒv�3�E񣀜bZ�O/F�=xчr����|ďgH:)<��O�Dn�f��7����9���;)y�:��ptr��]f������}�q�3�
g�m�U�	R.J)�d�pH�!�����CƄ� /l7�'��=9���`�!P~�h#@c��#B�ҹI��8��8�UB]�دE7JP����R�;|]iw�<k;n�]
�&�a�KA�}E�"����($O��[��(�7�`�B�p=m�:ء���{��L��J�dQ(J��\������!�b��i�	�F8�����2���'��=;��M7���+o$`�ۗ�7Rӳ���)��������\\��GD'>@2�Zf-n�Ӕ�#(���3E��co6;k[Q?WӞ& �%��U�ˣ�{H�Pg�p[�׺��C2����#��%n�3����H�j�r2�W]�(���so����(I�s����7�c&uĳ4\
p�p~�T�V<����~rI�z�r��B��^�H7X���O��Q �,�r-J��+KlԤ�纪��
���`�^=��&�q"��l�)d��=���2ؑP�t"v$Hۈ𦯗��{��.�zb�Ǆ�~�Gִa���IN��H �ڨA�Nk/���y@�^�r�/3؉Pn���N��������ȿ��B���6�ԋ~�� �2�G�.��Gl<�҅�0���>�u��8�gq�������g�r�bvA'%���5�nd�M*�];�GMj��lY5�`�kW��	��2*�"��;���-�|k�� �����r�c`ta`���^8E_�:�H���M����R�E�.�s
���#f t��S�b:��l�f��1�AQO���O���B��Y_��E��h� A�DA��iIz&�:U�T~PSn��]t�jW����q�A�2p�٤��Kf�A�2�fsɐ�kܘm��~�Lnn�A�
b7�5�8$q�M����EbO�UCbOB�l�H�L�w6@5����jZLJHEx�~e^�y(� �F;'�k�DQ��3(F�>�C1)�^zE��C��^��&�yq�UOH���`*m2@SE���C,����tQ��MkH��pR�[�'��Q	�$��u�I��mA)bDI���?J�jePt��!Ξ�[�ʢ��1��_e3��L�FY��X%J+��((���D����ټJ�I�{�����?r���"����;|R��,����(��b�r�Rr�6��P�^|5/a�~-��P�8��:��(�E�:�}P�P��Q�O[��Z>�#:E�.[n ٸ�z��ؼ�zԜ�N��e�N�&v�m�)?�`2*^�;�3�K��"8e���-MX�ʔ �Mt��|#U�����ߓ��I��I�2�?�i٫��
��G5+��-C�`���u�n�
�]�զC�����-���y�T�.�����$��)�g�-(3�MS� �G��F�E˛������z4�ZưnP�Zѵ{[jU)�;�5���iԔ��E�n�Mm��_��9؊���p��̊:x��夞��9���Ϧ=�!���Pԕ���� '��G�7�w���H?�l��/g'uR���J����b/�ٯE�x�GO    �V�w���
ڴ�lvI;���J�c��:���[�}�&��طЯnkv.��?���v���}*�΅�v D#��.@�{�ryx�WV�(����?�eQʊ]r��"�8ii\��[�!��˭�+����/����R���zܾ[����MܐK��]��2�Y���0��X���ʤ,:`?�%n6��s���M.����v7�e�NJ��{�&V�9ܺ����b�)Dȫ{���:��Z1o�6����8�SL��=)U�y��IYu�N��lz�G^�.0���LJI"� ���?�����8��pnq��Cx	o�����Mb��&�B���0Y�c��꼪Lo��H�j��lʤ�Q���9R'�$��e�d��qL��0.ZIOJbJ�5=m̀��G���=c����b��G&�ґ}�"�E�w˸�lM�*���3	eG�}!u�&���X�n�S����ʯ�~��a]�B3�K��+A�/���Jq:d{�{�ep2��O�}bʬ�H���z�9* �W~4w��p���纒��ܮL��h����N�A��MJE�����.��Cb%�����갨�b;m8��4��"���;��0e��Nt�|D]�c�&δ�!�R���#n���X�Ya�0{�F�z����hkb��S�rH,�N�>%mqRz�l�#I5)1pr��I�8����+��oY�o����j�u.�c���ȯ�0m�f~��������M��!m���w��ߖ�ev�3��9n���Бk�b�֠
����*v+�ERߤ��Lٻ�ر@�ӎ~᭧�c��sǮ�ͬS�3	I��Ղ�����^�$e�J�����^����e�]�4v.�4�H�,ta�Nʪ�^�x�|ީK|E�6����[����I��3~����'���$J����G�4��'(a�N�o��]�G�$U��"�I
���-W}r&)8���w�Ǉn��c#��YN(���З�1�����I	Rc���+ۘ
�k��Q��%��8�3��w������)�ˀ&�O�X ��� ���an#3���?��0w�)�n�:x���jb&ƬW�Yj���^��EW��p�L윩��m?Ko{�	�0	�{��� k`��;_����z9����j0�� iL|�ħ����$���?&a��R*� �e�]��$�jE������)(����;�����\��8'@�g1�	���J�e'�*YĀN>zb%X`�r?'-'��w�8_6�K7��Pf�]�����VR�$nX��dRv,*��6�����Q�)/�N�3�}'4q+�*��oI�d���^ڢn>*࣊ײm�l�V�I�1&�?>���(�?��9֥��x�i.F�z��3$8ɍv&~*AP�/�VrK5Y\�;]g	G�d��:�M5�!Ph.?���X�^$rIdM7N�9]���~�D��^�M�H�ܔ�)o�C�����7�-L|z�M%ޤ�B�v���	��w�x�E��R�7�,�#tZK�Ϲei{�㺞�ɃB���Ľ,p�	>5���P���4�[J:M)�84A�Y)���	Io���y��Ɍ����-?����H�1Aȍ���Vӕ��N����i����b6=V4u?�&q�6�˱�>�jU���sX��O|[�Î	� ��֚�U���� @��m�n<<�JO���>IC^�=Y	��pt8^Й�49ɞ���iV�R�������Iu��@���HI%|::nW�b�ttH.�f&�Ī�2o�z��k�M|�q�q.7Nd���o�U�7z��]���p:L��'R�K�z&�+Og��]d��)���t\-kr# ܔC��]+����&9�&������%q�vv��Bxm�؀e8?b����+�^:o���q��v�o�se�K�@�zN/��1${Y�2J�D�:�C;nK����$�%I�|si0S����${/���r�G)Vl�W��ωl��O�4*q/~������x7�I�����{8q��|��+[��[�U��j��MN�5���4�{��
�pX��i��O �}1 ��+��U}Sj
�لڊ7[���&5q?kS����@�40�'��;�,0e~K�LޓQF���Z"�o��+s�"�ُ\��%RF�����Z�$Dȏ?��[�fy^��+Sxɍ���4��t��JE�r�ҩ�L���n+G=s�*�GM��5#R���s����iQ�s�P,�R��7p:�$���|�����*
�O�t�s?�ǘUA�C�����ꅄv����~-�	P��v/X�����>�����ҫ)+3}RV�z~kUj�{b�B��$'�/ܴ\��C&������� �n�|�4:��2Xۋm.��.�r�cR*H��{≐0=)���x�@Sk#+1p�{L'~�^�����'�k�ڂ��6tP/*�a���#u�䦜���^\3��r���&�8��e3M_�'�s��.�*7��#n�����ݶ��#n��>��p|gM�[�����Jx�Ii�+�V~ ��;�V9(�{x��s�@i��\�MU��վF����躣^� ��1Ɍ�����P.�.
:UO�%�ڙ1k�j̐
;�{��*eLס�]1����k%d,G��׎rR��s=[����s�R4�ƚk�ى���#�^Kn�!�(�F�-:�+����-I2�nj�'eƘp��}sb�".L��k�7m�K��,�L�zI4y�~��'O���E�e������P���ݶ��=U�^y�e�zQg>	��f��H�
wU���r�w��J�r������*��uQ���C2e��7-��M�)�2[T�����	���0�O!� �M�wc䔄��߾������0y���A����p�u%��LYg����!��Uwǻ�rh.�����~jk�x-�7��T�I]T�C��C9+:p�|w�ENr=�\ 
���2�Y�q_M�������c�rq��c��T,x��;��欧�<�_����4�-�@̹�c�D��\:��4\�ע��p�q{5���=�����i~��~�� ��������id�6H�ڋ��L����J�M�S)��EKL+�W}��3�w[^�����dכ:�I���N�I�������{��7��E��=��6�FNg>�\����4g�aK}�X������0yvt���L�� ��ٙ[ė���sp��(��~��Jc
%|r���O��	>7�x.��Xv��e��ө�.��u]��7�v�sR]�%��Q��->�����m����(,�,|�G0��a�>�=V�b����.o�C.�����M	w��gvev6�<�;);(ݪ���q�lgR��kʰ�a܄��v��tx��Z�=O&=6FC0���ͣ`EW�� L���V.F��Ր�uG?s���C���?��b@i��.i)S��n�,SĖV��؈�W�F%N��Ӽ��>_	�TE�t�LB����=�Q��H
�0�/D��{�Z�$(���� ����P��5&��v�!�Ť�@�J2뿆V^
@	���C��S���:U5���P�
b7=���_�\��9�iR��9��Ф>��\bP��%F���GL&�^E�BSbV.�\�%���`e�g��)%�����Ϯ�}�"�#~_�X���:N��ΤTa����eG؛ �(ߙ_%�%-��6ӓRqruԒ�G���M���J��q/"X��z1��*�A��3�Y"�^w�[��I7!���^���z\�bv0\S�0\��0�e����ᦌ��ѫnb�vv2Ъ7�Ri{��,��fೣ�.Z.NʦS=�Ic�,8�.��FlpS�g!�}B3P*��y	�7�{�l<�DL�,%b?�Rⱡ�Wٲ�$(�,�m�U�YJ�L^s[�A�o<K��n)��Y_�{������]��+E��"�W~���M��T�Ogf�` ߹�U8�	�[.A@�����zq�fN��p֪b�k\U* *�A�R�~����C���ӏu����0OĆ��6��g��{Ȑ�(}+��-�ܫ���>{�N*rq����%�lI8������ZL;�?�*�f~�WH�7Z�7{�19�:����Ch}�W���    Pʊ��o%�?�8�F{�{�λxŖ=ɘ�QN�	d!��2-\��q��窳���`*��v� l/G�]'�j�}蘞!U:�2K��yQ�VFwh}/�ae �*���톀u��'��oYǙ�-\4`Ý�����+��c;�&\<����	��ܮe�~��Mle)��s�%E=Fn�u^�2(��((.�v~`����Y��O7D���Ƶ�A*xŅ�~س��Tq"<�[�%G_���%������%!O��^��������<|�ǺE��ש(�t��VCQ��.%S�i�g��!sez�&�^o���O���c��q���H�q�D�jV���W��)���.x�l,]���h�sӰ,W�Q��*���b�� +s�1�<Rc�f���4�V����jkv#�X����M��k�Pcǘ���ېتun{���g���'�ڜ? ��Z�s٧Sħ?���{�*�z]���o�I9)�3'mݛ����s�Ԥ 5<�b��_�Զ����3�n
�%i�n$���sQ�U�b&�V��p��2�%�˺�u��[��%�<U�f��+�k��0�t>�y�y����׬��:n�'��W\�C�.����1)� �TF��֖<s������)�u;r=MKW9ܵ��\GL-'NtT3�����ŝ�s����\BI�P~�[^T�}6��E��ۏk���ikn��/����4�5��,g5q�Uyg���
�q���:pؐ�xp=>�k�e�[Tkg*�uK����-9�bR��=lZn�o*�-`�lAf�ol	�|�nP������˂��i��$kZg����$-L�W�V��0N2�ƭU����X����6t�^�� <0r8�S�,��v�H��~E�v�.]$,�.I�ݹ��
���P�g���#��B��Yp���˿��{Á��2��~<L�.b�t���T��W�&��t�N�#�!y�X}V ��������î8�^خ��%V�ͮ����rH܀%��M_ॸm�}���8&�8z^M~�?R~5<V�8*�rT��#S�-�һ*E�̷P(� �<V�2�Ǵ^Z�
�����_�k�2~���������ģt����m��Uꒀ%��3���	iv�����3mG7J_8񳯐�_6R�b���-�����Pt�/�����F-(L!��2��E�u2�SGon�]�x�L���Z��CC�-=&��E��5�f��Fb�1�;��������J�=�ei�-=~���"����}����.���k7e�	�?�m5�-�v�XO��_�n�d/N�Z���o�r�"�Sg�j��)/l��~����S?������P��i{VM����^��0x��o�$l��Đ.��ˡ��5v9��"���Y'i���Ԓ@���[��9�92�9� t�sY�h�ݲ TP(u0��4v���3v@�@�|ep��,�8VnF	��4����w����@~�n+�@��{��8��CQJ�R��ӱ[Q�Ŀ~r2ق
x��K�Ȗ3������Dn�V��NOmE Z9G'���9�B���#`��骭=�/2����e[M����P�n�SG�*��e<uDrx�))���u��	Q�����ڿ�x,�+�5���~��P�7]p�)e{U�Ѷ��H��{��ǓRqWp�����^�w3Z�*=[���W'47�7�ע�0U^Ϲw�s=��JB�M�H�>ܙ,������VX��\k����`o ����:��i�{�y�W��n^|��	+*/Rdo�:#��ȍ=͍�7v;ܼ-:)(}��<l=��1�n��C�u��ҳ�3O�Q�p��
<w�EmB%Jm�9��b)md&�dk�F( ��!(� �=����bs�[s(H�#���
t��<��bf��z=�Yҍ���Ex�Q���Ͳr�F�K�E�p�r��5l���~هAI�P��~U�r_Aߍ�5j�k��F]���6R�r=���_zX:a��Ů^��kC�ץ�CRq�%��:Gם?��S=d=���B�����S��*O'N��Ѥ5��+��u/I��O���+�ר����9��L?��Fr
����=��$�u�zL(�;t��IƤ{i��>��w�|�y��r/?.�܍��NP3�x:�SF�E��+%������ؤ��)K��||]*�j`<?b��ݠE�G������~Y�����o�]�=}9{i�����q�WI�>Y6vH��pS���Яn����Nc�	�A�����r^O@IK���s/*���ʞ(�4�MA��&M u�s�@�5{^@y�^{RnF_��%��ܞ�4��-v%X��A9pF]��g��	�F���(�-Z�iF��-l02Rb�&1־��"I��9yvS
Hs��R�n��(7y.�^�����c���o1܋b���]rb�E~�L�A�
�X.�-�/4/7c�
�/�\į+��w���+�
|ԁ�M���h��e{��AiOiA�6-6�6�#+/�5~�����P����^_1��B�v�-(��;�-� ��8.v�_�nuU����0̏x������*�?^1�i������)/����T�K����!c��v!;Ǩ��AK�O\��4�6��d�ø�-��"S&	 9W����Ȑ�άl�Oz/�u�rt��K+���ջ=�z�O�킑�>Ի�S�n��s:�\��y�����7���VW����u����7Z�lt!p���)������Qg��p ��ujX~Y��7�� ����������/I�(��b�)�GCj��q�1�6n|���
ע��k���v�"_��E�{��	�����,6�	��#\7�*G�z�Ƨ#$�S/�?���3�FX7���^�i�~%���+m�Ι�~X4[S�����	�<�)�7,�?��t��Gt��AN͏�=��$+��r`�p�-R2��@W������\�&�`�n���������׭o-�Q6���u�p���Sֈ�r#$�k�?�T��z�׶.�����)�$I��O�h��$]Xr#)D~Z�H��u��`�c=�����WYճ�	����{����(��*#��/�c�]�,���.�q�,�\D�G^��]@#���YLGY�qc�#6KA�ۇ����z� ��9���QB�s#+H�Y�����"�z`�����e9����z��,�&&q��F~�)?#r��FD1����=&�[���}�z���ܣ ���mA�*�F�z��s�>���)лH�r� �|�1��$�J=�~XTj̱z�r�N�ͤV�������|�ϣ{�O1���3jǀ�8���y£u�}O���j���K��U�8߮3q!�\*j*�j���=&aC9x�/a�˿e�T,�Cf�YS���6�z.��l����|���c���	Nw��hC'��˦ܗ7=(�/�����kI)�n��+D��bt�E5zQ��ly���8r�$������сP�����[�����q��&$ݤ��Lm�9��w��b�"{A)���P|`W�P6r��1 ������L�V��̶L�m��m�|>Dť�^�1H��U>C�?5h�pN����A@��ʾ�ԻJ�1�euY�!��3h�F���}�=/M�����(cJ&vK#��3��`�i׫d�7Q�z�߽�:�NO�P�ҭ��W����6�K~*YƗǹzf?&GSS����T����mJ�[�`�{��x>�m
@����^���a=�y@1�ʽ�R��V?���iƄi~�(�(��L��ֵ��+���KH��g?Q\tN5�;�=j�<����q�t��XG\��x�P�y�z�I����k�PRo�m�$�T�),{�r&��y�G��צ���,�_�U&�߼�9eʊĮ���������iÁ>�u:��Ζ�D�����,����s�r��/dU%��v�(+Jn{N��ٚ��f6�f��B�,](l
aC���������4gt+�ދ0��" T�[mT�Ҩ(#�X«xi����JT���Z���s榢��3* ��TS����T�~ܳԩ �"n���]���ͣ$t~{T*��    ���]�n�uQT�N�F��I�/[jפgثr��1��ߔB��s�̼�� ���T$�%�ڇj�%�vH9ħFI[xա+�gᵹ�����f��p�ko*���zjs�G#�1sj`�Z�)�eO��yr{��ǽ$>���E��6X��&BJ����-�ۂH����v�75���|�T��i������sG�=��r=�ԓ�e/}��2��h��;�z���4;5�zսJg5�1&�i�sq�s�]�̋E6��]X���.� !�ǣi����oi@�=��>��P�ȫ��O��������Pvj�y����y��:u��>��Q�O!h�s��6���_���x�Cbh-v|��w�y��7� ��{I2�	4;�/3��^>* ��&O��β�!�	|�]�J�z��1�]��ע��p�`8[��-{�M0�?��K���$%�Q�#f���W������I�A��3�{ٶ�q�Ob��*�%�1����Z���M֮�Q�g`�ށ.#��8m��0�j��3��r�V=I	3���������9D�j��?���������Ww'����N�J�*�㯶�X��)!���6XT��oMʦ���3xR
B�wn|<�Ҟ$�6��+���O�"O{G��xI.����ȉc�7T�m����bNb �f�Mʪ�����n�P��xy3�"�@��*��}2gR��F1��a��sa%qn�l�$�ε�1�1�o�v�6��z����I\��^?�IYU��y/f�Zt�z�lRv�tSV'�`�VfWC�����7�1�??����&�l�~]� �����SrBS�W����\�h�X�g�BP�~>g�-���Յ��X ��<	��Sp4)'1�O�2�3�4�7�ز�Qg��2����7�'M����5c�S���ϔW�Z��-��2�7�qgv�1���[C��g'�[�=}�+�#}��<�z<����ؕ��~��@�2����`��g!��'��}�I>���;M�6@�֕K����c��ї�=���7ܞv��ע��4S�|d*�V�����mg�x#�!g7���⓽2h8_���8v3H=s?Z�qZv3�?���d�T�/���ahfU��'d��z��e.H�Zp��7igS[�}�{���äT�<�.�Y��D�'�B�K���란�����,���eZ�I���	_d��1e~�l�zt���[3)�%D��/:=d�1Ȳ�<�̉��\��q���=D��G6�0޻ߓ�*���ls�YH�v{-��6	�^�j���m�v�ߛ�ǮQ"�W�xF=��y����L��F�a5�(�X�g7�sbPX ��
!�_k�	L��Hgv
u� ϖ��"�M�1������¡����C�b~՜�FL� _�Fv&���-�y� ��1*�)gR�$�ndkRf��'�(���������F�̉��/��vo<����J��F�qօl�g|I��2(�c/"E��tTG��S�I����Ğ��]2��f������U1i7�s*︗wL��%��w��tҰ,I�8@��s ���Co��\噃��{2�S�y�Z_�=5�#$,���ߥd�'�z�n�)��OW�X�e�I< ���6�l7G�Lz��k���>����O�c�%*���;�^S<��$�=w�����}�wCv��8N���M��acY7�ו��Zt+�e������Ýɖo}9[���C�T�],`�l�j`RE��qj���}�;퍱:{�|]����J�{x�xpqn>f¸��"��`�٦̏�a	�����o�t�
�v|����I6tA��ȏ��q���*Ș"!N}6e�1o���tE�ۻ��a���3���yV����y��NJe%yƪ;���C@6���v�ml��&7eT8Z.W����V��5�,V��{��e�<;`b#�٘��I��zR*y�,����㘹��l�8z	���tX��̍�e7=O {����/�>n�,.���w�$V�<�6��G��-}�f�9���)Ju����t)7c1��(eRBй�GDh
��P�<�*ۙ�yO�1�ʺ�Ҽ̯zb�����~�.ʨ��k9�'gī���$�푰%.O�
En0R;K�}D�a��bM���L[ڐ�:�����uk
�-�+�]�!w[��7{,�� �-��7��F���.���y�^��"�Ӈw�l�&wc�lVw�h�&���y��e��|L���р�`DrzeI���ބ�l�t���۟�ħ�<���V�cr��N74N�cJ-��e��)�'S
Fy�Z�O�C��|Ɓ���&�6s<N6?1Rv���/�N�	?�κ�e�ېI�5�SJ�)��p�MY���������D����cW�-9�k���=h.o��x����!�'ce)��Fj��U�|1S�M-�Mt�V��ϟ���K7�K.�a71�x
�ڷ\JrL���j��ڔ6˾���tt^��W�=�E�����j�C5^���*�^�`��C�1����ʔoS1��T�@��2T`�1J7wD���8�㋺=RZ<�c�]��������W,&94Y��zr�d��/�s9�:N�vl����|.[s )I��Xe�w���Ec�36���4_�|!n+w�Z�����E̰����K��?�gzzg|�}�*e�o�� �R���o{���ā��#K�L�>䃢k
޷�2�#��ex��h�%!D>���E�c���_M�+��Ux��dw|ŵ^d��u����_��ƽ���Io�xmq�����Ơb�7a۩C�'*_�X�B8ɽ	^�q��OXM��D���Y����ȼAef>�a�&��q�d��J��g��dSv9���d*$a�[NnBF�гO�>�
����ˋ��Ӂ�>LwBۋ7)���X��`{E:�g|AZU88�[lC^�Ky�����Ka����|B�`��r��V[�E�dE3�5,w�����-7��ec�W�T�	2�-8W��P��������o����߷3�&2�۪W������/J��o@=������������]���:R2��Ĝ9�m�w�$�^��*�����+9��x�|�-����q���&�ݔS6*����`ŗ����; ������	�˺oZ,:R���0k��&y�P�M��|�e��Nگm��,�פn��y��~�)�m��eC_�P��Xy	����崄V����`Y/N�b��Tag�{o�M�@ř��c��G;{ĥ7��-�e� !}�]�Cl��ƲO�R��!b3�p+�UC�wK@Va@o����f��]�,b��*Q~��O���l�}�����i��*je|~���d�Ω�v�ń�j9�b*3�W�J��qi�:��f���X��R��	Ui��C1���M�����]ViTt:�����^�����)Z���A�j	��n��&^�	���� ���=X$T�����i;��,�"����K2TQ?(j��Gv�)ꢼ)	&�ޏ�v~ȎN�}������	��f�i��v�c9��`�.��A���V�e�aަ��O����V��Wut�2ʅ���(���`[:ůÊ��P�������x�lхn�INk7����aM���9�f܆���^��6�ņr�������Ut=�+.B�C�I���{�7·�w��V��*�,V�>�ԙU�=��J̊��~�QUat5�����Ŀ�#�"�nD�j��M%f]�R转�A�%�f�A#�rh�.�O�o�hp�%K:p�$G����9~�Ǡ��SPx���3x�9����-A�	��E C ���*0:�:���6X�C�O�C�㲥���˩XW��\>ϭ�V��<��s�s#6e��ߚ�%F�� 1��r�rKP� ��#��06�Ҕ����/���\U�5�.�bt�#-���k�ة�ka�p$i���Vd���-����oA
ǪK�G꬞t/�j�[����+Q}��²�Z4=���~IuswMˌS�sx݋�[f�bK������u�ʂ&�}G��V3�[!��X+�]�_+ӕǼ�7�Em��;��7Hu�n9��    ���ɇ�[V#�*������c�ƑP��(m�U��yz��HN�����y��f��dN
�z��I|���'��û<�w��M���V's\���[Ua�_��:���,�|H$�U��������S�[#��R9񇋰��.��)��jy�y-��Z�5C�xk����Ԩϩ�!�s�/'�$Kc����6EkK�l��|<�S����*�Q7�aZg�W[.W���q��F��,%�f�"�n.HAG9�m�ǒ*����G_��8ӬuQF��֬�wt�<�M)�.���
-�|��6�E��SgSC�\���F̣.2x�$
�qmt��(]��EQ|��(씿)��_�`��z��ڦX
�C]���aM�Oa�(�g���Bt*`5���] �A��U�k)գ�񺛰!!M��.�qɊބuӴ��ZQ�l ����HX��	�J�#aݴj�HX7�V��wl̿�O�W]��}�k?���K�oH7}	H�}���/��b=5���_Kv}]�@bF^ڍ���Q��t�^En��v���&>L굶��d�+T3r�4|�8W��7[����r=�%ٟ�3�A0���1&����ލ�� 9� �O���NOHO�I{���Mء�b�����`O,���̞�<=j���h?)��`��\�M�y�j0�|Sf����#��J|BNm����Ѕ���̟����c�=g~�9��?�S��,"l��=W�F��8dk]���̢.t^�̜�z�ڹ���D#�H;*�������]�d����R�l�,[S�dA㺏H��{S�XÒxA/b/�.�^X��D�?�&�$�4a�s"��>襋��q9��[)��	n�wG���aBRV������Aӿ��"؊�Cp��u�XMG�\t-���r�3�eO�L�Ϟ:�Y �:a+�Yq�������:�{�K�Yg�:��Q��W�(�������*V����7��Ur����E>(T5���z���YWb�uޤ���&����Y/�18�����MN��@��PlO\��;���Kƈˤ��H�*=E� dE6�����0�ہh�D����@�s�8.n�[ϡ��������!�/�C�8KaIqZy��_��]�]0�d�l �#��ccQ
N�z��>����B��x�0�˼����M��n��;�����]כ�-��!Ġ�U��3zC�^xY�c�!L�K����C$^�z�3���|�}�R
S7��^��Q�N��H�lU��?~������>�O�Ma��>�ȴ�����aU�k޼w��R����ğ��}l�c�e�9�{���L����ḍ`|��9[_�_ '>���}6�r��@���#{"e�8���:b^36����ݏ/�K�
��8��zJ�ߍ���Қ�V���H�Z���s
�*�ژ�n@�U�b��A%5�Û��ݥ��N>�a��`��_����]�Tɒ��`	�YO>4*X�b�$+�o"��<R����3#��6�Y/���I]/'�T�H�R�����R���}2=�`9u �1���#1?�!��#�gn�\7�MFN��m�(�}>�ԃ���E�y���42K=����@��'#3D���7+���&�|N�p�ȝ7��/'�#:|YF	ݭ�ܭ&�m�)T����$�J�}��'/{$��E��Q�����(Y$�[�	�գ�R�S7�����Ӣ�Q�q��QXř��0&�,?7%w&/S^ �İi;y=�Y}�;3P/�63Fe���t8*	�'�pO��9*sOl���(5x��m�N�
L�8���a�c�v��~�%�t�|u�6"e�[�b�C��'?�{YǶ�!����2�����,�j�����G+Hz��3���6,��y1��U�xߩ�lr�ZGʋ����L�)=��m��c�*�����$�O��}�ɘ�o��g܏t��_Tϓ�[kҎht�(����9�;X�J��dKC�wt�)�э>x�BCu��g4�ʍ�8�I�����K���$�1��n�1� r=F�ǆ^�1��y��2��Ų�l�&v�!���Z�`p2�ͪ��X���Dg��2A3�����>��K��W�>��8bwm��f�/�(���$ܔ�UD�E�bLv�L��3F�)�8�dL�)���݅)0	���1�p�����M�O5t�_`e9R����T,�wt��J��������X�N������Q��ܫ�>��zd����nᓧo<V��S]�'{�q-�J���Kd�%��BҀ$��D��b
}�
��:�Ӈ���h���A)�����e���ta�q�d�dQ�=���8�b�-�/� ")/����_L���?��d8O�5/�D/C5G���PG�DC�9]�o�'���J'zp�pF��O��"9��P���!wO۫N�0ԋ"��t���}�d��b�7�-�W3����U���Ӛ/cG}Y��4����d��τR�n/c����x�*�w��0#���;�xӷn
cE$�B,rg����[0�˂���ڊ�E���$���4KbJ���g�ڭj�,kfI���L�T&I�%��}�Yv��G�t�)jf=�@�ffZo ��~��!�Y�F�_�	gY4����E#�7a�D�^��x<�9I����X����[�V3�%���C�y햃��� 5�j���+3�E]��Sdc�u�u�6���Y�)�8�l����lY=2f+,�����e�+2[�m�돗��)6$[N?{��k6�#x��9�(��0۔�)��{q��h�<�;u6��t6�H ;�L��R_����Β�S~��@t�lX|}�B���쬁g�r��egK!N���
���������v9y�Ɍ�p;D�E���"2�N-�_�"zp�o1#"t0�+��>����}�&\5�ǀ5(�g���#G[�6<>@̆� vu��y���a��?��=�g�a��Dü���LNi+���5���r�M�/��.ר�p��0������KlJG��Է(vϚS�����eukXW&�\��}8	�Ͷ�Э7�U�:W~M_���/Cv���T;T���1���x��P�{s�����1B|���М�sb�;�9��le�`q.���E'l:��i�Ōt��§���h+I7#��q�
����	�Jq����/V�Or�ш�Ǘ���B%��/&L ���4^�Pj����Vb�����c6��G��㟆M�GWy���.��5�X0"�!YN�唔��l[�F9�D������e.K�/Q7��޼�iANdϮ,�t���2Cge�,����L��j�2�S�u�۬,"���۩�t���y���Ƨ��.t0`� �5=v+4�[�c@b*<��?[���r���j��x�Ȭ�}�\��0�֕]�f�"�D�����S�S6��͍U)q�|S:W�!��ރU��h��ʒ5����� ��Q/O�@�W5~���3���J)�}I������m"��o�F��qA]U�)��X�1���V�|>���U	"���?V�(ڪ�F9��F��%>� o	&�s��6f���|T)���I�V�|�n��5� �6��g��՘�����&��9B6��L�K�jP��� [��1�F���D������q�eOo��Ջ�s�YyPVyz?_+��;3Ѣ N��NKX�sԙ�x2s���ǋXK��Y)]�J�>E�D���"��9į�؉֥U�sS�Ҿu�
W/�kYu��R�־�C~�*�Ď��`���sU���b:�gq	����b�/m�Mu��nK,t?��`��B���<-t=�������­�6����|<���,��n3��U��,��dM�(��3���� �R6�ˢNn�����,v����H��dܩ���|X�;��Q�5	&��G�?���E�Ge� Ӷ��Ds�'>s~�����R��S�g��@q�9c�&g�5�p�����ńFL��W}IT~|�D��su�F��b�j�g�h�˵)N~>�ZHI��L�z���ו�2�@�ycU8w���KR`���,�±�� ���fU{o;oC�`�@ק�;{ӇA
�    Tm���=�Z77! �ӗ^0������r�]ɐ����=0M	�Bb�80.��r�nӸ����BF*��Ab���ΐXG��V��/�P
�|�]X@b�����M�:HE��=je�9�F�����`��o�ra��&������و��� ��:���:���,�S�>�Wj.�%z7r@�������߳>��nNG��t��|�;�J���R��W���w��46�e�԰uS.%��r��&��w(����R�(�+-]�l@Y�q�8�]���f���p�/���HMB-�i��*h��
ZqR-TFKM?��~<�n��霙��2`[�[s"��_X�`v�'�2h��MZ�.�&�	h�����ܲq��z�����>�&�a����h���iB��{>K�<>mK.�(P�+~^؞��������N�M��%�	��@ϙ�=�P�Ot&�uC���FV��bSҳrd(�{QA�ϡW=�綴~�qY��.\v5������.PI^��᲻�%�%�
=.�{��8�~�l��$�a��ŋ�)J��&��rnz��hJ�9��aG�#v3�!�ŕ+0D8�Q��W��90�~XUM�V�nl�\�=���$�=��N�&��L����=�[�LA�݀���0�j�`�3L���E]5�&�F��0�J�s�˷�P�#�a��y���k�`
`�:Շ�,A�Q����맨ER�_C*�vG�>����8�s>O����[q��iwM�f�lIFޥ����h�U�7`�1��g�;��aΡ;�^��n}ܐA���M�
P��cs�}Rf�1���m��	��Y�������P��ʶ�cM�-;&�=��M�W`�.��R�<�Al���O{I��s Sw,R����[�������M �� g�@�D�c�M�$�qH��f��t6�ֻH)ޤ�V(�6��WX���`���&��d��G�)�<�����N=�u���I�|�M��"��&-*��qU��,X�ى�Te�/��&���q��bdCI>��ӷh�	b�X�'�4�ܔ�kz��"��]6�p� ���l���.��W� �7B�����D�M�d�y>w`Ǿ��
*�7�P<iQ���RBĩ\(�M������� ;J���S�צ�*�څ�D^���r%|���N����Ƀq3�s�V^��sg�cG.��Ѭ-����- ��ۥ��FWk�znKj�;�ږt�N}�z4j]4T	̓���j�
N�e�4y<�9�Ԓ���G�4EˢMOQ�����,ڪ�j,o[����S3-�����mRF��я�]L4F���"��ۆ��ݖ�@�ؤ �&c��j�]_<8�N��=j�Ag��ﻠ�7�Pa��&mJ�2Fz�.���5��E|�~�ne)�����XR��i����=��+վ%'};~N�ۡ�
GfLI�<��cCx{R|_ץ'�&3�"g��H�6΂M|��E�a������#bnK��a�u��C�]���r@��o�I�ߣ�6%#vcN�$B+h`�	������+�Y��2+�K�O�!����m�<�5)?Zӏo�*���c�� wE�ү䮨W����j߾ّ"w�M�6R��er�p!������iQj��)W��� U����.i�=�C}`ly&�
v���״��B_8�C�U��:^��;�-ҋ�"���Qk<1 �& �j��� �Gsz>�k~���/#%��M3�a�6\�M�]W�2%h|j�/a�!�o�y�����x�.* �U�n���H���-'���f� ^��𗺴�U�o�&'���m��ȇ��>���I?6��k����*,,�ܤ&��n:�+J4}og�Ϩ uS{�����KA ���Rxe>��,�s>��,B0J�ؔ]O`0!��I�x��6����A���ޯ
�MjX�������E�3���Ƀ�[ѯx�����K�~�V�;RD
�w!����x�F�ti�b�"�C.F�ya�6��z����H9�2L ߤ���셪Ʊ�Xf��M��[\��b�4�ޯ�����l�~��亐�.�O)آ~\�y�\}Z!�W���Gu���DJ�ZM�ٵ�e{�Jz.��Q
U~�.��@[��.�����f�h����M2���-M���rÅnVi��(�H���͋e��-m�a��-0��M��t���8�ނS�^ܫj1�&XE�U<�>-30�MAg��l���Sx�e۫��]�9��JS�+�����ZnbEB�"R *YۤVXE�ӹ���"8��+��k7A�[�w�ߧ�RnF����]1�ǔ)���ss6
X�2�I����Z�����F�?[�oR,Nj4p6Y!�gޏ}����h��&
*�=GE��R©\�^���y���*R��`8%0%�4�q^�jP��D����ŷ�\p����Q�����p���ZL�O�����l�a�).�e;���7JO�m]�|�]74ȉW*���ǭ���
<�Mp�/�fI`�\�w�QC�D�G�3o�1���%��V�b���e��"��ۙB��Y�}�\CE�b�⤵M*��n�h�V��_��K�[yY�/���� �`b:H�dT��I�~~;{] ��X�ȰI���hJ�3��̻��{�kseB+6ҋ
u�Cl0�Q�&��Y_Ѫ�e�^Z@�g`�5I��rHIR��^o�mH#�Y���l���*����P4T6G�:8뒊&,n�&�MV�A~?H�K���(4���4%�Q �L�Ji�f����iB=�i[Y ��;�p�X�-�7���%g]7�XR���5j�Q��7a㒅��)������2R��x��s�i�v������"�X 3Vq��F���/�s2�a)I��WB	��2S����Et@P��M���6��������c+�4��]�7�pVa����A �:�=K��G�l2���?��%2Q�U^�G�V�!�)"v��R1��+<G�2�r�I�*h�"i��;�n���"��H�\�U�Y&E��Xɟ?����=F���t2i��aI��	}D��>��.�n�,����j�0�
 nR@Jc�*Y.����ɔ~���|��
Y���1nf�݇ѬV
����nj���V3��@�"��xoP�GӏXg�6�$�9[b6��nrk7�`v!ڤUѠX�
+��g��A���5	��)!�z"�K�CI۹L�o\�O=���5}З���Skv��gd�aa�-��&J���j��Q�s�]I�����PFS�u���e�Ga�0�֒@�ui��2Dv���bIK��7~V/�q�<�����?CM�9��)PE���EXN7��2Eq�O���̧]��S�Pfׯ�U����M9U`�I6�pӅ�<Au�ka�'��8^悳�|�++)�Ïve���L��eU��]���_J�`�y��������H㠺�w��Օ�9��t_`��E��H����·BF#�h��ĕO}D�1+�Yw��f~u��s��|���h�]�A�Y��ڂЅDCupŰB�dPzxx�� �s����������u�㼬`��5	*|6�Y�����I����T� ����>P	�?$��d�{�/�^S����� ~;fO��bo:倒�<dY��V��秣���<QR�	�h����ĝ��S�PXk�+�G��OVv�F�E��w�Y��DޟjV~
�}7�H��a�&��7����S?�����da�:?]E���˂�e��1-II��j'e�
ŁNY#�i��
SL�����Cb/= �XQ6*�
�]�(z�������ZD��wмW�)R�!�y���_BXi�nl�9��j�?Ԕ�WS�|V�P��쇧7T�a`�5�8���pʦ�꼊��{�؅�伸��I'���y�ͭ伸J�����q6B��j���l�8�R����0%usB��Æ�v胺
uՍ}lS[�v�*�o���� �����d���B��ٴ4��O#>�E�M=0�8u
|IA�n�Y�)1x��񻖳����Z��e���\�pG��VCf���0��z՝pQ��A�Ш+�ޅ_��{�� ޚЛ�L��r��?��}>��'    8��[��B�
���0���|k���#+�������(��$��a�"���H�`Ȯƞ5j�K{v�<D��^x���5�)�\n�H)&�''r��)�˕���;1�0��i��y��H��xk�*~�2:\���\C(#iҰ�����B���xIF*�h�@��F�>6K��h����8z/˧�|8��2�z��P_��i�r0�:F�y|�jj�v���aA�N�wg���>�q�[Sy<nf��kي�JQ��Y��/raT���]~�:"�E��P8#��"���b@1����f��(�`�`��&��7����&Ѯ��^�ؤ o��-	R񽨥,�]vZR�؀�بeVs�e��%�T��^X�|��AlsZ3V�k�\��J�^�˲�5����s7��x� ��-'Y�����)�����%'5�^2�KSJ��w���|V3E�eF��7���P�3���.�-O%��h��K��g�Z��nY�_܄��$��Z���V�>?�kZ�R���@Q�H�gK��_J�0�gg#�E�d�u_���&}��󢱔*.�Z� I�>}�١��+�J�����b�$5p�.J����z��g�����f��e��y0�e6�q�$�w(�wp�C�C��|�E�T����7V��K@}�G�.y��i��N�jp4���LؒF�YD��٪$��.Y����jA��pU���O�l�o�t�m�3�L����TkS�/�0�	hMP��ڡJ��Am�$�>eW�y�U�ٰ���i֣�[/�@ԕ�6^vu��#*¶�-#j������ ��v4Z�����gE?���Y�H�����.bp�����V%=7���J��H�Q����QY���)TQ��F*���XzU�u"�65�	���UC:����8��ؼ�f�*Q�T��h&��m�`�6�1��"�Ïj|	<�d�	8U[E���d�j�s��bBp�;���t8�3u��v��ѥ�r����3���Ϣ_�?7r[������n�m1X���k�k�[N-?�2��r*BA�Fe����	e#��[0h�h��<ٽ]��y.�M�L#����l���K�-�}9N��Kld ��
m�}>2M��k���V�(�H#j�WЇ��@�R�1��b�	N*@��~���rȲS����h�A�}S�3��i  ���y,�k�Q[X�
EvOԕ�'a.IZ5me��&az*J�-�Ͷ��n��T�ǋ�d)CvQXߓ@GIz̠ճ�m�(Cv�/ؓ@g!�$��wJ	�^S�x.{��[f��Za�U�U�4
P�&:��-�3�tqq��`��۳�VS��:~<��Kcx&WϠ�/n澯�LZT�>�^T�zӏY�W�"B����~Z���e\��D�8���W��	��+��X:������
ڋ池��
�_. 8����5��cGm)����μi*��U1٩�=S����&Os�~��ܛ��G1or�;�(n�o����� 6��w�D�s��rA��Ɇ�1�f:)0il���_ڄ��7E+t,�V��U��]��UoM(�Z�޺�Ƽ�/R�/c`�]����7F�"�ߛ�u�w���zg��D(��hW�&B/�Yr40Omp�0g�.�]U��.<|��7�y]0��l�RN9�ѕ�wa/*�:yW(��������P�~{���¡(��P�'���>�2lT$ӇC�Q�<��lFQ����<��������7��C�+���B���fϟI�;J6�S�
g\lRa�l��z����֣UЗ]���Τ�2����B���J�X>�M��tH���$�ź�(�䲸j��e�Xtg;��}hrY,v\�"����X7���<+��ɳy����}�U�w�u����AmX��C�f'��a�1�I�%x�Y$toC��0;�C��f�t`�n�!P�t���څ� Y���x]D:^���}s���>R�3���+"?��V����� goPߐ���Jx���HM>*J��+��/�ҳ��~f_�$�f���hF��T�W����4�V�_J� �v�?(Jө�%]���oEj �MS-�{���$�SM�~�Q��ډ���H�g��@=Z�M(��+�']��:+�^&�z��Ί"��/>k���xP�G�/4�Y��DdF��X�������E�O��vg����0
c����p�9�ti��0ʔ]MX��$�s�_��F�]%)y:�MeZQ�B3xTƪ����Ҭ�jT��y��؝R���E��xl�̣��%^�*xœ�F�±�R��\�]�n�)�uR��Уè3c]J����Xh��ts�ټ�k�@���o�V���E짦	����I��xpJ�����𳴕b!,��>�}T�׆�D^��R�i���]��U,�*ݠ�ptA�롾nڶ]uW�E�t�f���RȄN�a~�<�N*��[GW�b?,�n�-G�,
fNQT�kx���N�2��{0�%�����J��/��O�s�z.J��R��"e����mJ���2�,:g�c+��m�ف��rU�8�q���J�b��C���(VV3ƒ�
��c�����`�X+�1���:�.��Q��0˛����0ŷ��0j3���4|a�rY�}�jQҮG�z�[�5�$�����q�B�C8�
�Ɯ���n1La)���w��
T��q���ϩCde�ىleV���+@�"���R�J/itu��[V���)!��X�����/�����vbcM����3w-BQ��X�W��M��{�@�k�0�_!��z̓���W����e�8>@1<Ba�Su ��f4D���(�w*rvʥ"&
��~��gJB���0�R�-'h���� k���߇�Q����7�:� _^g��L�t��`��f�b�LKI�\�Ķ�횙)i�iT��M4u��*��\����Eu��2+��$F�#��l�$�� ���L>ɅQnJ&y1l��gs0Ku��°&�Z˅�$�E	Y�|�BHL�\��9�u�E�/��i��I��rٱ�"|�M�r�E`�����8r�0Fq��,��E��,K^䷜��*�/������+�U�u��h֬�r[1_�Յ{Ve�ж�Uى�1�c��S<@zV������f�
K�W�Y��p¬ �k�&|���M�*�䙭�� Դ����5*��;�d�N����\&�+0���h�ǪCV#ؓ<�f��$�E��\MrW�`�����	�����u���3֫�����V��=q�!��eѮNVg�.�L�`����*�e��eg�J{�͚u?� va^t,V��]�|�9�l�M+�93zsj��a�93
Иao?��Is0f7�h�jT�B-t���C^�^����<�M�����i:�zs��K_��˼�֤Ŵ�İ)�1L���A�aQ���aܬ��ŵ�,A�%�VڕF��V|ߟS8����F���H��S����s*\���jVߌ��T�� �%����7G���J���㷳AdV�~XɃ�o�<{]�F{�k0��{�������7u�)�I�~����薐���f�?��=�*����7��.`q���"�r�S#y�zػPu������2A�Bт��~�C���s� �D���℩{M=�)�tZ�zak_��[�����j�֟+)Z�T���J�6�?�Wu߬T�"[s%���]I��o>�ꯪ��֕�.k	SO�~x}W��t5�hǧ$�?�h\ٵ( �m�ĕ��m��9ehӆ=�7u�,/���bs��,�E�q~eٯ\�â���M�@?2���]Y�Kt��j���ָ1
�0���|�c��(ڶI���Ԩ�� 92�
"92n��92��y1������6Y��_h�cD.�U�HW�� ��Җx��إh).X�6l�D9�eܴwX�Q�*U`J�?����&�j��
�;�* �N�U���U��dvUc�sNM�Y@]B�ZU*ф�G���=W��L%�?���V؋_ƹ�R/
�U�)�h��0*h�4��W{UI�p��j�S|�לr��[N��s�:�|�1��[T@    ��%H����0�aC<�*���nR�\'�Z�3H����l��]8*�s6�]�h~%�i����=��]����>t�0ܺ�
��T\}��	�V7��m�f|���^\A�C8� ��&��1$G����aQ�m��Y/�Q��фa�1?"ٗu�Z2hN��{��JT����_��㻆Aj�2ٳ��R���r�+NS^S�+��i�jH����]�ӽfQ\��ښ&)�5,�h��q�Z��e���䰘W��E��<[�U=i�y�<7ŀ�����≌`����
�hQo+�U�1M^����q��bzi���M��B^/����xpt��+۬{�C�Rي�5y���]]w?�{7=d��✧��߶�b����2�A��(mx�!ɖ���YW�/(r�C���*�ߺ@���v>UC��Xe��H�M���0e�P�ғ5�t�X|��$��HY��.k� u�K�HE���$F�\�/&��+v��$b�wy$+��l�(��X_����
i)a��cV$��	��B��6�YH�����?�}��_�!W�U/w5�AV��{�K>a.J�UG>f�C��"r Y+�Y�L�Uc�a<(Iqh3@Ί�(�4{���_?��ʆ�;�إ|F`�T�uS��?�Q,�r;#�Ϥ�RB�k騂�lJU �X��>>ƒf�i:��[��]�g!��b݌v�Y�+;�i�Lg���ETg�Q�o���H�ƫ�sYN���k���qs��Ս¨KV]PAv L>�&pQӧoJS/�ƅ&H-v1|%=�׌ �uc�Bc�.��@�rPA���E�K~��6O�ӥ��o]�G�Pq�64e��������}���ݠГ��ټ����h<09v��"�tᩰ������AW�ر~PAJ8ѠV���+ź.�;#En�c#�&�|q�F�vڄ�UH���3k�pT�s䰀���@�
�1��[N�1޺�a����p�ހ������@�,S�Y��ƒ�G�S��6��[�\`-�������Y��@���i���q��:�ln�Ɉ��k�!+�C����/�K�l�	�S�-XI�)����r�������eH�Z`	R2Qk?|",�q~�І��(nx�]դ�sX�Y��>��ͮJ�@��}�KIQ�ːeK��PCi�����T��3�sVP嬄a��{@~f�{�.e]�qA��Ǻ�'��O���j��/�xE�� K��g>�0V�[�/dSY�Sh2��7�����������L�������?�L�y�^���?�� ¦�f��1��nJU\�elo�E����te���r�2�a%��c�����&,ht�\�6m�(�n�6"�1'�6��:��uk�-�m�`ʰ�_�yq��f�N	��-�i�� ���"6{>�Gy��Sf���S�o�Ɯ߅Pj:m�,�~~[36-;�7)�U(��Ćmi�d
ҭ��2^�C;����C7�1�Efq�XnZFLu�
"�7!��?oR,L5�&��tts������ˏҢN�WCr���h���Y�4�۝��5]�nR�(���i˜m�[���4lb��㢟u8�d��^̼����v�)��~�ͬ�~��U$�1G;UJFW�N�.���W��&ڄV���ԃ��>�t)�,�����\Zo��%�&f����rU�,̂�E����a�;�:)���-��:B/ݵ:99q�pv�&�
C����W%�v*mQ�t{��$�v:�5G���U��;IU�,KF�ۛT�
+ 6iR2v�ș|0Z�L�n�Njhu�Ԡ
n��t�������I��jҩf�Z#�Å�Q��Z�'Z��TF���~�����,��m�;%���D%П$�t��fSw�?����D��e�uR�D��%qխ�)8����Tpz����pT��	�(�ԩ��� <��T�%�ɒ���>�ZЊ�Xw���ß_#f��!�:��tJ�"�E�tm3�o���x��G5�Mￇj7	��H
N��> `�
��t�5V��p  �z%h.T{�l�+LU:��cU���[���V!m���X�R���v��2U6�
��i������d��n��Q�񦋎wZ�_�1�s��
��������I�j��
����ɗ�lm?��KI3�ǻ�[��	��������j�}i�2o�X� ���ڃ��t(�#/��� �[�������9����z�E%l��9���3<�fK![X�
�v����u� �wIi��Ygս|#T{�s���7+�|�S"d�-���(��_�ί��_:��\��L��r�T������������x���&ԝw�G�G*h���	�Zn�r&wF�H��-Uz.�X�m�s�.��f9A�O'{��+B�U�˨٪M�u�2��d��ure�Z�T��9@28;�d֛4���V�iB]�鄱I��Q�=7F����-��ѵ/7A�SÎ���x���n=l#�c����������p9�7J�7?`Mc��{�rkn�c�?87F��ͬ�w�8^�.�}䞄q�yA�ҍiW�c��Ѫ��_��a+V�[A��&�H�� l/��2���x�z�w������i�u�.��&5P�K�+4�:��vJ6���,��࿔0���Cx��]3�"����YP�E*�&�e(lJA��G���2�%*��8:�7Y2G����C�7Q��T�E��<��r���}�ٹ�Қ��Û�_�*������6�U�$=�8�{/����!q ��8�+@y�%Ӥ���-��J�m�d��Q���%G�Qx�'�-?�2
�g�pTVu��a�SՑ����/�qTN�=�l_�u���>�W���jx΋�ġ�Ϳ�ȁ����|w|�d�����71�(�w{`/-�f��89�5s����e��Y�~�(���z��X%H�!ڬh<z���:��w�zT�K0R%�$A���'Y\�q 3�JR���Z�k��/\ts���Z�Y[�.�L�����%5=�/I���"b�4�M9��^/�!��K~�c�D����,F	zV���/��Y&�IQ�3pȫ1&G�,�__JB��
W��r;�N��^����"�x	>ok	�@���f���@���������/N8(����!�^�҂ȟh�F�*�b�>6(}n�
Vq��¢tV�`U��	��ߥ4��(��c� ��v)b`H���	���Nn8� (xߔ�V�F��� ek�����d�RUaq�O=��_�fU��?H�К�\ij�>:	3��0�X�p)��Pa�@u�U�����N�ll`)��jl�4rV�DH��(w���`E�8�
��/*�6����p�M-���T6�b�ڌ�"94��T\l<~UD�ߤ.R�j�7e�v�㬐S�_d�b�8�G�y5�z�
ɍrkt�������$�F���l��rkܴ�ۤ]?�½W���ގ�?K���-��.r�/��h��Q�e��:�^��u!hGV~rm�";�k:�&c�.�j�`��,�2���4�2���hL�&�.���n�� =*���*��d3� ��of9%t�8�vR�)�n��kyzM��3γ��BH���{f�ͮ�k>j��~t��t�N=�Tf��+f��䌴����e���e�RV*�~�Q�Qg���la���,�w�̦�*������Soi�e5=��垱6g�҂W/�p��.�V�a�G�r�ʚJ�YZ"lA�S�GA�c�Ǉ������ϲ	�����R��"�h��?0����]W@��_�m�?��Tb@*y���4�IE��ړD7on��S�^F�z�;����O9���u�?ʬ���Q@���,��԰�\�ϩ�w�&�����ոI���7�Е�7]�:���������侠.E��Wڝc�M�S�+�.�MRU%��^�l;|p�s���b��)��^����E�g�ǻ��Е5P��L�Ϫ���"H�P͊U~�:X��f��f�t(�Me��b��y�
���ɖ\�$����Q�X3�^��?��E�b�Uq�E�   �ۨ�,���c���6��T�ģg�R(�V��k�b�T-�]�m���qKY1�[�?��P��
Z�:��0�I]���*������WA*Q;�料1�$�:����VmQ(�V�,*#�wL�I[�+� g.�:dc�� �D�q��*�_�ke�.R6kSY^p(������DR��}�6�^����W��	�����z�o{�+����8�Xi$��ŀ�`mKnfӟ�;5Q���X�
������������     