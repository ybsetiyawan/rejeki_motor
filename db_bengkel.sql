PGDMP                  
    |         
   db_bengkel    16.3    16.3 �    l           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            m           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            n           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            o           1262    33752 
   db_bengkel    DATABASE     �   CREATE DATABASE db_bengkel WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';
    DROP DATABASE db_bengkel;
                postgres    false            �            1255    33753    generate_kode()    FUNCTION     �   CREATE FUNCTION public.generate_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('kode_sequence')::text, 4, '0');
	RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.generate_kode();
       public          postgres    false            �            1255    33754    set_default_kode()    FUNCTION       CREATE FUNCTION public.set_default_kode() RETURNS trigger
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
       public          postgres    false            �            1255    33755    set_default_m_supplier_kode()    FUNCTION     �   CREATE FUNCTION public.set_default_m_supplier_kode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.kode := LPAD(nextval('m_supplier_kode_seq'::regclass)::text, 4, '1');
    RETURN NEW;
END;
$$;
 4   DROP FUNCTION public.set_default_m_supplier_kode();
       public          postgres    false            �            1259    33756    faktur_sequence    SEQUENCE     x   CREATE SEQUENCE public.faktur_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.faktur_sequence;
       public          postgres    false            �            1259    33757    kode_sequence    SEQUENCE     v   CREATE SEQUENCE public.kode_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.kode_sequence;
       public          postgres    false            �            1259    33758 
   m_customer    TABLE     &  CREATE TABLE public.m_customer (
    id integer NOT NULL,
    kode character varying(4) DEFAULT lpad((nextval('public.kode_sequence'::regclass))::text, 4, '0'::text),
    nama character varying(100) NOT NULL,
    nopol character varying(20),
    alamat text,
    no_hp character varying(15)
);
    DROP TABLE public.m_customer;
       public         heap    postgres    false    216            �            1259    33764    m_customer_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_customer_id_seq;
       public          postgres    false    217            p           0    0    m_customer_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_customer_id_seq OWNED BY public.m_customer.id;
          public          postgres    false    218            �            1259    33765    m_item    TABLE       CREATE TABLE public.m_item (
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
       public         heap    postgres    false            �            1259    33772    m_item_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.m_item_id_seq;
       public          postgres    false    219            q           0    0    m_item_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.m_item_id_seq OWNED BY public.m_item.id;
          public          postgres    false    220            �            1259    33773    m_jenis_item_id_seq    SEQUENCE     |   CREATE SEQUENCE public.m_jenis_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.m_jenis_item_id_seq;
       public          postgres    false            �            1259    33774    m_jenis_item    TABLE     �   CREATE TABLE public.m_jenis_item (
    id integer DEFAULT nextval('public.m_jenis_item_id_seq'::regclass) NOT NULL,
    kode character varying(20),
    nama character varying(100)
);
     DROP TABLE public.m_jenis_item;
       public         heap    postgres    false    221            �            1259    33778    m_satuan_id_seq    SEQUENCE     x   CREATE SEQUENCE public.m_satuan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.m_satuan_id_seq;
       public          postgres    false            �            1259    33779    m_satuan    TABLE     �   CREATE TABLE public.m_satuan (
    id integer DEFAULT nextval('public.m_satuan_id_seq'::regclass) NOT NULL,
    nama character varying(50)
);
    DROP TABLE public.m_satuan;
       public         heap    postgres    false    223            �            1259    33783 
   m_supplier    TABLE     �   CREATE TABLE public.m_supplier (
    id integer NOT NULL,
    kode character varying(4),
    nama character varying(50) NOT NULL,
    no_hp character varying(20),
    alamat text,
    email character varying(30)
);
    DROP TABLE public.m_supplier;
       public         heap    postgres    false            �            1259    33788    m_supplier_id_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.m_supplier_id_seq;
       public          postgres    false    225            r           0    0    m_supplier_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.m_supplier_id_seq OWNED BY public.m_supplier.id;
          public          postgres    false    226            �            1259    33789    m_supplier_kode_seq    SEQUENCE     �   CREATE SEQUENCE public.m_supplier_kode_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 9999
    CACHE 1
    CYCLE;
 *   DROP SEQUENCE public.m_supplier_kode_seq;
       public          postgres    false            �            1259    33790    m_user    TABLE     �   CREATE TABLE public.m_user (
    id integer NOT NULL,
    pegawai character varying NOT NULL,
    username character varying NOT NULL,
    password text,
    id_role integer
);
    DROP TABLE public.m_user;
       public         heap    postgres    false            �            1259    33795    receipt_sequence    SEQUENCE     y   CREATE SEQUENCE public.receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.receipt_sequence;
       public          postgres    false            �            1259    33796    retur_receipt_sequence    SEQUENCE     �   CREATE SEQUENCE public.retur_receipt_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999
    CACHE 1;
 -   DROP SEQUENCE public.retur_receipt_sequence;
       public          postgres    false            �            1259    33797    retur_sales_sequence    SEQUENCE     }   CREATE SEQUENCE public.retur_sales_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.retur_sales_sequence;
       public          postgres    false            �            1259    33798    role    TABLE     n   CREATE TABLE public.role (
    id integer NOT NULL,
    kode character varying,
    nama character varying
);
    DROP TABLE public.role;
       public         heap    postgres    false            �            1259    33803    role_id_seq    SEQUENCE     �   CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.role_id_seq;
       public          postgres    false    232            s           0    0    role_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;
          public          postgres    false    233            �            1259    33804    t_retur_receipt    TABLE     #  CREATE TABLE public.t_retur_receipt (
    id integer NOT NULL,
    no_retur character varying(10) DEFAULT lpad((nextval('public.retur_receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE NOT NULL,
    id_supplier integer NOT NULL,
    keterangan text
);
 #   DROP TABLE public.t_retur_receipt;
       public         heap    postgres    false    230            �            1259    33811    t_retur_receipt_detail    TABLE     �   CREATE TABLE public.t_retur_receipt_detail (
    id integer NOT NULL,
    id_retur_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_retur_receipt_detail;
       public         heap    postgres    false            �            1259    33814    t_retur_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_retur_receipt_detail_id_seq;
       public          postgres    false    235            t           0    0    t_retur_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_retur_receipt_detail_id_seq OWNED BY public.t_retur_receipt_detail.id;
          public          postgres    false    236            �            1259    33815    t_retur_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_retur_receipt_id_seq;
       public          postgres    false    234            u           0    0    t_retur_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_retur_receipt_id_seq OWNED BY public.t_retur_receipt.id;
          public          postgres    false    237            �            1259    33816    t_retur_sales    TABLE     �   CREATE TABLE public.t_retur_sales (
    id integer NOT NULL,
    no_retur text DEFAULT lpad((nextval('public.retur_sales_sequence'::regclass))::text, 5, '0'::text),
    tanggal date NOT NULL,
    id_customer integer,
    keterangan text
);
 !   DROP TABLE public.t_retur_sales;
       public         heap    postgres    false    231            �            1259    33822    t_retur_sales_detail    TABLE     �   CREATE TABLE public.t_retur_sales_detail (
    id integer NOT NULL,
    id_retur_sales integer,
    id_item integer,
    qty integer NOT NULL
);
 (   DROP TABLE public.t_retur_sales_detail;
       public         heap    postgres    false            �            1259    33825    t_retur_sales_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.t_retur_sales_detail_id_seq;
       public          postgres    false    239            v           0    0    t_retur_sales_detail_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.t_retur_sales_detail_id_seq OWNED BY public.t_retur_sales_detail.id;
          public          postgres    false    240            �            1259    33826    t_retur_sales_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_retur_sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.t_retur_sales_id_seq;
       public          postgres    false    238            w           0    0    t_retur_sales_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.t_retur_sales_id_seq OWNED BY public.t_retur_sales.id;
          public          postgres    false    241            �            1259    33827    t_trans_receipt    TABLE       CREATE TABLE public.t_trans_receipt (
    id integer NOT NULL,
    no_receipt character varying(5) DEFAULT lpad((nextval('public.receipt_sequence'::regclass))::text, 5, '0'::text),
    tanggal date DEFAULT CURRENT_DATE,
    keterangan character varying(225),
    id_supplier integer
);
 #   DROP TABLE public.t_trans_receipt;
       public         heap    postgres    false    229            �            1259    33832    t_trans_receipt_detail    TABLE     �   CREATE TABLE public.t_trans_receipt_detail (
    id integer NOT NULL,
    id_receipt integer NOT NULL,
    id_item integer NOT NULL,
    qty integer NOT NULL
);
 *   DROP TABLE public.t_trans_receipt_detail;
       public         heap    postgres    false            �            1259    33835    t_trans_receipt_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.t_trans_receipt_detail_id_seq;
       public          postgres    false    243            x           0    0    t_trans_receipt_detail_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.t_trans_receipt_detail_id_seq OWNED BY public.t_trans_receipt_detail.id;
          public          postgres    false    244            �            1259    33836    t_trans_receipt_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_trans_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.t_trans_receipt_id_seq;
       public          postgres    false    242            y           0    0    t_trans_receipt_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.t_trans_receipt_id_seq OWNED BY public.t_trans_receipt.id;
          public          postgres    false    245            �            1259    33837    t_transaksi    TABLE     !  CREATE TABLE public.t_transaksi (
    id integer NOT NULL,
    no_faktur character varying(5) DEFAULT lpad((nextval('public.faktur_sequence'::regclass))::text, 5, '0'::text) NOT NULL,
    tanggal date DEFAULT CURRENT_DATE,
    id_customer integer,
    keterangan character varying(255)
);
    DROP TABLE public.t_transaksi;
       public         heap    postgres    false    215            �            1259    33842    t_transaksi_detail    TABLE     �   CREATE TABLE public.t_transaksi_detail (
    id integer NOT NULL,
    no_faktur integer,
    id_barang integer,
    qty integer,
    harga numeric(12,2),
    subtotal numeric(12,2),
    modal numeric(12,2)
);
 &   DROP TABLE public.t_transaksi_detail;
       public         heap    postgres    false            �            1259    33845    t_transaksi_detail_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_detail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.t_transaksi_detail_id_seq;
       public          postgres    false    247            z           0    0    t_transaksi_detail_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.t_transaksi_detail_id_seq OWNED BY public.t_transaksi_detail.id;
          public          postgres    false    248            �            1259    33846    t_transaksi_id_seq    SEQUENCE     �   CREATE SEQUENCE public.t_transaksi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.t_transaksi_id_seq;
       public          postgres    false    246            {           0    0    t_transaksi_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.t_transaksi_id_seq OWNED BY public.t_transaksi.id;
          public          postgres    false    249            �            1259    33847    user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.user_id_seq;
       public          postgres    false    228            |           0    0    user_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.user_id_seq OWNED BY public.m_user.id;
          public          postgres    false    250            i           2604    33848    m_customer id    DEFAULT     n   ALTER TABLE ONLY public.m_customer ALTER COLUMN id SET DEFAULT nextval('public.m_customer_id_seq'::regclass);
 <   ALTER TABLE public.m_customer ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            k           2604    33849 	   m_item id    DEFAULT     f   ALTER TABLE ONLY public.m_item ALTER COLUMN id SET DEFAULT nextval('public.m_item_id_seq'::regclass);
 8   ALTER TABLE public.m_item ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            p           2604    33850    m_supplier id    DEFAULT     n   ALTER TABLE ONLY public.m_supplier ALTER COLUMN id SET DEFAULT nextval('public.m_supplier_id_seq'::regclass);
 <   ALTER TABLE public.m_supplier ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    226    225            q           2604    33851 	   m_user id    DEFAULT     d   ALTER TABLE ONLY public.m_user ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);
 8   ALTER TABLE public.m_user ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    250    228            r           2604    33852    role id    DEFAULT     b   ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);
 6   ALTER TABLE public.role ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            s           2604    33853    t_retur_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_retur_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_retur_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    234            v           2604    33854    t_retur_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_retur_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    236    235            w           2604    33855    t_retur_sales id    DEFAULT     t   ALTER TABLE ONLY public.t_retur_sales ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_id_seq'::regclass);
 ?   ALTER TABLE public.t_retur_sales ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    238            y           2604    33856    t_retur_sales_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_retur_sales_detail ALTER COLUMN id SET DEFAULT nextval('public.t_retur_sales_detail_id_seq'::regclass);
 F   ALTER TABLE public.t_retur_sales_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    240    239            z           2604    33857    t_trans_receipt id    DEFAULT     x   ALTER TABLE ONLY public.t_trans_receipt ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_id_seq'::regclass);
 A   ALTER TABLE public.t_trans_receipt ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    242            }           2604    33858    t_trans_receipt_detail id    DEFAULT     �   ALTER TABLE ONLY public.t_trans_receipt_detail ALTER COLUMN id SET DEFAULT nextval('public.t_trans_receipt_detail_id_seq'::regclass);
 H   ALTER TABLE public.t_trans_receipt_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    244    243            ~           2604    33859    t_transaksi id    DEFAULT     p   ALTER TABLE ONLY public.t_transaksi ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_id_seq'::regclass);
 =   ALTER TABLE public.t_transaksi ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    249    246            �           2604    33860    t_transaksi_detail id    DEFAULT     ~   ALTER TABLE ONLY public.t_transaksi_detail ALTER COLUMN id SET DEFAULT nextval('public.t_transaksi_detail_id_seq'::regclass);
 D   ALTER TABLE public.t_transaksi_detail ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    248    247            H          0    33758 
   m_customer 
   TABLE DATA           J   COPY public.m_customer (id, kode, nama, nopol, alamat, no_hp) FROM stdin;
    public          postgres    false    217   ��       J          0    33765    m_item 
   TABLE DATA           c   COPY public.m_item (id, kode, nama, id_satuan, id_jenis_item, stok, hpp, aktif, modal) FROM stdin;
    public          postgres    false    219   ��       M          0    33774    m_jenis_item 
   TABLE DATA           6   COPY public.m_jenis_item (id, kode, nama) FROM stdin;
    public          postgres    false    222   �u      O          0    33779    m_satuan 
   TABLE DATA           ,   COPY public.m_satuan (id, nama) FROM stdin;
    public          postgres    false    224   v      P          0    33783 
   m_supplier 
   TABLE DATA           J   COPY public.m_supplier (id, kode, nama, no_hp, alamat, email) FROM stdin;
    public          postgres    false    225   ,v      S          0    33790    m_user 
   TABLE DATA           J   COPY public.m_user (id, pegawai, username, password, id_role) FROM stdin;
    public          postgres    false    228   5w      W          0    33798    role 
   TABLE DATA           .   COPY public.role (id, kode, nama) FROM stdin;
    public          postgres    false    232   yw      Y          0    33804    t_retur_receipt 
   TABLE DATA           Y   COPY public.t_retur_receipt (id, no_retur, tanggal, id_supplier, keterangan) FROM stdin;
    public          postgres    false    234   �w      Z          0    33811    t_retur_receipt_detail 
   TABLE DATA           T   COPY public.t_retur_receipt_detail (id, id_retur_receipt, id_item, qty) FROM stdin;
    public          postgres    false    235   (x      ]          0    33816    t_retur_sales 
   TABLE DATA           W   COPY public.t_retur_sales (id, no_retur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    238   tx      ^          0    33822    t_retur_sales_detail 
   TABLE DATA           P   COPY public.t_retur_sales_detail (id, id_retur_sales, id_item, qty) FROM stdin;
    public          postgres    false    239   �x      a          0    33827    t_trans_receipt 
   TABLE DATA           [   COPY public.t_trans_receipt (id, no_receipt, tanggal, keterangan, id_supplier) FROM stdin;
    public          postgres    false    242   %y      b          0    33832    t_trans_receipt_detail 
   TABLE DATA           N   COPY public.t_trans_receipt_detail (id, id_receipt, id_item, qty) FROM stdin;
    public          postgres    false    243   ky      e          0    33837    t_transaksi 
   TABLE DATA           V   COPY public.t_transaksi (id, no_faktur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    246   �y      f          0    33842    t_transaksi_detail 
   TABLE DATA           c   COPY public.t_transaksi_detail (id, no_faktur, id_barang, qty, harga, subtotal, modal) FROM stdin;
    public          postgres    false    247   �y      }           0    0    faktur_sequence    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.faktur_sequence', 258, true);
          public          postgres    false    215            ~           0    0    kode_sequence    SEQUENCE SET     <   SELECT pg_catalog.setval('public.kode_sequence', 11, true);
          public          postgres    false    216                       0    0    m_customer_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_customer_id_seq', 12, true);
          public          postgres    false    218            �           0    0    m_item_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_item_id_seq', 7052, true);
          public          postgres    false    220            �           0    0    m_jenis_item_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_jenis_item_id_seq', 50, true);
          public          postgres    false    221            �           0    0    m_satuan_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_satuan_id_seq', 14, true);
          public          postgres    false    223            �           0    0    m_supplier_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_supplier_id_seq', 38, true);
          public          postgres    false    226            �           0    0    m_supplier_kode_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_supplier_kode_seq', 11, true);
          public          postgres    false    227            �           0    0    receipt_sequence    SEQUENCE SET     @   SELECT pg_catalog.setval('public.receipt_sequence', 136, true);
          public          postgres    false    229            �           0    0    retur_receipt_sequence    SEQUENCE SET     E   SELECT pg_catalog.setval('public.retur_receipt_sequence', 22, true);
          public          postgres    false    230            �           0    0    retur_sales_sequence    SEQUENCE SET     C   SELECT pg_catalog.setval('public.retur_sales_sequence', 12, true);
          public          postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 5, true);
          public          postgres    false    233            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.t_retur_receipt_detail_id_seq', 20, true);
          public          postgres    false    236            �           0    0    t_retur_receipt_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.t_retur_receipt_id_seq', 22, true);
          public          postgres    false    237            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.t_retur_sales_detail_id_seq', 17, true);
          public          postgres    false    240            �           0    0    t_retur_sales_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.t_retur_sales_id_seq', 12, true);
          public          postgres    false    241            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.t_trans_receipt_detail_id_seq', 169, true);
          public          postgres    false    244            �           0    0    t_trans_receipt_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.t_trans_receipt_id_seq', 136, true);
          public          postgres    false    245            �           0    0    t_transaksi_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.t_transaksi_detail_id_seq', 78, true);
          public          postgres    false    248            �           0    0    t_transaksi_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.t_transaksi_id_seq', 66, true);
          public          postgres    false    249            �           0    0    user_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.user_id_seq', 19, true);
          public          postgres    false    250            �           2606    33862    m_customer m_customer_kode_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_kode_key UNIQUE (kode);
 H   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_kode_key;
       public            postgres    false    217            �           2606    33864    m_customer m_customer_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_customer
    ADD CONSTRAINT m_customer_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_customer DROP CONSTRAINT m_customer_pkey;
       public            postgres    false    217            �           2606    33866    m_item m_item_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_pkey;
       public            postgres    false    219            �           2606    33868    m_jenis_item m_jenis_item_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.m_jenis_item
    ADD CONSTRAINT m_jenis_item_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.m_jenis_item DROP CONSTRAINT m_jenis_item_pkey;
       public            postgres    false    222            �           2606    33870    m_satuan m_satuan_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.m_satuan
    ADD CONSTRAINT m_satuan_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.m_satuan DROP CONSTRAINT m_satuan_pkey;
       public            postgres    false    224            �           2606    33872    m_supplier m_supplier_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.m_supplier
    ADD CONSTRAINT m_supplier_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.m_supplier DROP CONSTRAINT m_supplier_pkey;
       public            postgres    false    225            �           2606    33874    role role_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.role DROP CONSTRAINT role_pkey;
       public            postgres    false    232            �           2606    33876 2   t_retur_receipt_detail t_retur_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT t_retur_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT t_retur_receipt_detail_pkey;
       public            postgres    false    235            �           2606    33878 $   t_retur_receipt t_retur_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT t_retur_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT t_retur_receipt_pkey;
       public            postgres    false    234            �           2606    33880 .   t_retur_sales_detail t_retur_sales_detail_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_pkey;
       public            postgres    false    239            �           2606    33882     t_retur_sales t_retur_sales_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_pkey;
       public            postgres    false    238            �           2606    33884 2   t_trans_receipt_detail t_trans_receipt_detail_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_pkey;
       public            postgres    false    243            �           2606    33886 $   t_trans_receipt t_trans_receipt_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT t_trans_receipt_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT t_trans_receipt_pkey;
       public            postgres    false    242            �           2606    33888 *   t_transaksi_detail t_transaksi_detail_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_pkey;
       public            postgres    false    247            �           2606    33890    t_transaksi t_transaksi_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_pkey;
       public            postgres    false    246            �           2606    33892 &   t_retur_sales_detail unique_retur_item 
   CONSTRAINT     t   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT unique_retur_item UNIQUE (id_retur_sales, id_item);
 P   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT unique_retur_item;
       public            postgres    false    239    239            �           2606    33894    m_user unique_username 
   CONSTRAINT     U   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT unique_username UNIQUE (username);
 @   ALTER TABLE ONLY public.m_user DROP CONSTRAINT unique_username;
       public            postgres    false    228            �           2606    33896    m_user user_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_pkey;
       public            postgres    false    228            �           2620    33897 &   m_supplier set_default_m_supplier_kode    TRIGGER     �   CREATE TRIGGER set_default_m_supplier_kode BEFORE INSERT ON public.m_supplier FOR EACH ROW EXECUTE FUNCTION public.set_default_m_supplier_kode();
 ?   DROP TRIGGER set_default_m_supplier_kode ON public.m_supplier;
       public          postgres    false    225    253            �           2620    33898     m_customer trigger_generate_kode    TRIGGER     �   CREATE TRIGGER trigger_generate_kode BEFORE INSERT ON public.m_customer FOR EACH ROW WHEN ((new.kode IS NULL)) EXECUTE FUNCTION public.generate_kode();
 9   DROP TRIGGER trigger_generate_kode ON public.m_customer;
       public          postgres    false    251    217    217            �           2606    33899    t_trans_receipt fk_id_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt
    ADD CONSTRAINT fk_id_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id);
 H   ALTER TABLE ONLY public.t_trans_receipt DROP CONSTRAINT fk_id_supplier;
       public          postgres    false    4749    242    225            �           2606    33904    t_retur_receipt_detail fk_item    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_item FOREIGN KEY (id_item) REFERENCES public.m_item(id) ON DELETE RESTRICT;
 H   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_item;
       public          postgres    false    4743    235    219            �           2606    33909 '   t_retur_receipt_detail fk_retur_receipt    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt_detail
    ADD CONSTRAINT fk_retur_receipt FOREIGN KEY (id_retur_receipt) REFERENCES public.t_retur_receipt(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.t_retur_receipt_detail DROP CONSTRAINT fk_retur_receipt;
       public          postgres    false    4757    235    234            �           2606    33914    t_retur_receipt fk_supplier    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_receipt
    ADD CONSTRAINT fk_supplier FOREIGN KEY (id_supplier) REFERENCES public.m_supplier(id) ON DELETE RESTRICT;
 E   ALTER TABLE ONLY public.t_retur_receipt DROP CONSTRAINT fk_supplier;
       public          postgres    false    4749    225    234            �           2606    33919     m_item m_item_id_jenis_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_jenis_item_fkey FOREIGN KEY (id_jenis_item) REFERENCES public.m_jenis_item(id);
 J   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_jenis_item_fkey;
       public          postgres    false    4745    219    222            �           2606    33924    m_item m_item_id_satuan_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.m_item
    ADD CONSTRAINT m_item_id_satuan_fkey FOREIGN KEY (id_satuan) REFERENCES public.m_satuan(id);
 F   ALTER TABLE ONLY public.m_item DROP CONSTRAINT m_item_id_satuan_fkey;
       public          postgres    false    4747    219    224            �           2606    33929 6   t_retur_sales_detail t_retur_sales_detail_id_item_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_item_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 `   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_item_fkey;
       public          postgres    false    219    4743    239            �           2606    33934 =   t_retur_sales_detail t_retur_sales_detail_id_retur_sales_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales_detail
    ADD CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey FOREIGN KEY (id_retur_sales) REFERENCES public.t_retur_sales(id) ON DELETE CASCADE;
 g   ALTER TABLE ONLY public.t_retur_sales_detail DROP CONSTRAINT t_retur_sales_detail_id_retur_sales_fkey;
       public          postgres    false    238    4761    239            �           2606    33939 ,   t_retur_sales t_retur_sales_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_retur_sales
    ADD CONSTRAINT t_retur_sales_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 V   ALTER TABLE ONLY public.t_retur_sales DROP CONSTRAINT t_retur_sales_id_customer_fkey;
       public          postgres    false    217    4741    238            �           2606    33944 ;   t_trans_receipt_detail t_trans_receipt_detail_id_items_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_items_fkey FOREIGN KEY (id_item) REFERENCES public.m_item(id);
 e   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_items_fkey;
       public          postgres    false    219    243    4743            �           2606    33949 =   t_trans_receipt_detail t_trans_receipt_detail_id_receipt_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_trans_receipt_detail
    ADD CONSTRAINT t_trans_receipt_detail_id_receipt_fkey FOREIGN KEY (id_receipt) REFERENCES public.t_trans_receipt(id);
 g   ALTER TABLE ONLY public.t_trans_receipt_detail DROP CONSTRAINT t_trans_receipt_detail_id_receipt_fkey;
       public          postgres    false    243    4767    242            �           2606    33954 4   t_transaksi_detail t_transaksi_detail_id_barang_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_id_barang_fkey FOREIGN KEY (id_barang) REFERENCES public.m_item(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_id_barang_fkey;
       public          postgres    false    4743    247    219            �           2606    33959 4   t_transaksi_detail t_transaksi_detail_no_faktur_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi_detail
    ADD CONSTRAINT t_transaksi_detail_no_faktur_fkey FOREIGN KEY (no_faktur) REFERENCES public.t_transaksi(id);
 ^   ALTER TABLE ONLY public.t_transaksi_detail DROP CONSTRAINT t_transaksi_detail_no_faktur_fkey;
       public          postgres    false    246    4771    247            �           2606    33964 (   t_transaksi t_transaksi_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.t_transaksi
    ADD CONSTRAINT t_transaksi_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.m_customer(id);
 R   ALTER TABLE ONLY public.t_transaksi DROP CONSTRAINT t_transaksi_id_customer_fkey;
       public          postgres    false    217    246    4741            �           2606    33969    m_user user_id_role_fkey    FK CONSTRAINT     v   ALTER TABLE ONLY public.m_user
    ADD CONSTRAINT user_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id);
 B   ALTER TABLE ONLY public.m_user DROP CONSTRAINT user_id_role_fkey;
       public          postgres    false    4755    228    232            H   �   x�M�M�� �9'a~,�	mP� ���?G�fӍ7�{ֳ��2@�A��/:�Xs���A��^oTAq� �T�Fr�fzrV�G|�1ީu�g˲�Fz�,㭎!�X���۽���[	��6�->D���+A���=�t&^$r�5���DN�ϕjJT�S�==ƙ��)Vk��x�!>i/7�      J      x�|�M�$���q�*j��{P�Ԭ���G�X��4\&�G@A�)�g'#�+�>�O����������������Ϟ�����y�����Y�;��g���w���g��̾g�����������q���wֿ������>�8;���ϳ����;����9��������Hl�H���H��Gb��L��wW�=lc1�.f�'k�`� ��?�-컅��1�}ǰ�k4ְ��{�����~�1�ÿ{��={�w���`�D�1�ÿ{��={�w���`�������=���=�����c�����{���=��{�w�������#~�q�G|���{���{��8�#�{��=����{��=�G���`�����8�#�{��=.����{��=�G���b�����#�{��=.����{��=r���{�w�������#�q�G~���{\��=���8������"�{�`��NR�'�6��&�{�`���R�G�V��*�{�`�ڎ�=�}�K}w�߻���w��=�}�L}�)��a��.Sb�2�]��2�e��L�e��w�����2-�1,��eZ,cX��˴XưLom�e��w�����2-�q,��eZ,�Xf�ˌXƱ�|���c��.3b�2�]f�2�e�̈e��w��8���2#�q,3[�b�2�]f�2�e�̈e˜�2G,X�|�9b��2����9�e�X&���.s�2�e�w�#�	,s���L`��]�e˜}J�ໟ�]�e���2W,�X�~��b��2����$���e�X&���.s�2�e�w�+�I,s��\�Lb��]�e���2W,SX���X����z��)�������#������5^��L\��G���ۧ��}ٸܧɏ������x����r�(?b!<��>����K<��>����Kl��|�oxҷ����Fx�7>닇}�Ӿ�i_<����������o|����g~�3�x�7<����c�����/�O��'��ox��}�7��ox��}�7��ox�7�ǈ�  �`� `k &�� �
`�`� & � �`�`k&0���`�`�&@� �"`�&`k&P��T3�\��L��Ale�l��L��Alu�|��L �Al�����L �A	l�����	L@�A
l������)6��j�	.0x��� �؊�	20����@�`�Ej�P[50�6�en�p[708��r��[90A:��@���a�v`x`�&����z`�|`�&����~`�`&�!��`��`K&�a��`�`�&����{���L8��l�$8 �LH�Cl%�%8(��LX��l-�&80�Lh�Cl5�'88��Lx��l=�(8@���#6�(؊�	Rp��-)�0�)ؚ�	Tp��-*�P�*ت�	Vp��-+�p�+غ�	Xp��-,���,�ʂ	ZpЂ--���-��߹���][\0�]�����[^0�_���� [`0!a��� [b0ac�5��@[d0�e�U��`���Q����^���K�����p�38�
_8��|���38���\8��|���38���\8��|���38���\8��|���38���\8����7�b#8��3�p�3�:�gp8��3�p�3�:�gp8��3�p�3�:�gp8��3�p�3�:�gp8��g�38���S�����������I�gp���p�38�@8���?o ���Ο8��p��gp8���38���\8��|���38���\8��<�� b#8��3�p�3�:�gp8��3�p�3�:�gp8��3�p�3�:�gp8��3�p�3�:�gp8��3�p�3�:�gp8�'fGlg�u��p_gp�g�u��p_gp���F�.�!��������.�!��������.�!�������ş���Q�|���3���\8C�|���3���\8C�|���3���\8C�|���3���\8C�|���3���\8C����ob#8��3�p��3�:�g8��3�p��3�:�g8��3�p��3�:�g8��3�p��3�:�g8��3�p��3�:�g8�JQlg�u�p_gp�g�u�p_gp�g�u�p_gp�g�u�p_gp�g�u�p_gp�g�ß%Ỿ������.�!��������.�!��������.�!��������.�!��������.�!�~��b#8�ċߗ����_�g�u��p��o<g8C�3�p��3�:Cg8C�3�p��3�:Cg8C�3�p��3�:Cg8C�3�p��3��'��Fp�Xg�g�u��p�Xg�g�u��p�Xg�g�u��p�Xg�g�u��p�Xg�g�u��p�p������!�!������!�!������!�!������!�!���o�p��o8g8C�w�3�!��-��!�{���M�g���p��3�A8C���� �!���x�p�Xg�g�u��p�Xg�g�u��p�H�.����!�!������!�!������B8C�b�!�3$�!�B8C�b�!�3$�!�B8C�b�!�3$�!��1�{��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH8C�3�p��3�:CgH|7�B8C�b�!�3$�!�B8C�b�!�3$�!�B8C�b�!�3$�!�B8C�b�!�3$�!�B8C�b�!�3$�!�B8C���%^��t\�o�
gH8C�3�p��3�:C
gH8C�]�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!�R8C�r�!�3$�!��
�ΐ|�	gH�Âp��3�� 6�3$�eA8C��� �!��wZΐp��{-g�6�-g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��3�:C
g(8C�3�p��ws�!�3�!�R8C�r�!�3�!�R8C�r�!�3�!�R8C�r�!�3�!�R8C�r�!�3�!�R8C�r�!�3���^���K��E�p��3�:C	g(8C�3�p��3�:C	g(8C���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J    8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C�j���3���J8C��:C	gh8C�]�34�������P|_G�g(���p��3��Q8C�꿷vog(���p��3��Q8C����(���ŷw��p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(�g�u���p�Zg(����:C	gh8C�3�p��3�:C	gh8C�3�p��3�:C	gh8C�3�p��3�:C	gh8C�3�p��3�:C	gh8C�3�p��3�:C	gh8�ċߗ��}�a�g�u���p�^gh�g�u���p�^gh�gh~ƃp��3�:Cgh8C�3�p��3�:Cgh8C�3���8C�3���8C�3���8C�3���8C�3�p��3�:C��~�3�:C��3�:C���3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgh8C�3�p��3�:Cgx����p��3�:Cg8C�3�p��3�:Cg8C�3�p��3�:Cg8C�3�p��3�:Cg8C�3�p��3�:Cg8C�3�p��34?GB8���$!�a��O��0p��GIg8C�$�3���a����}������8	�gh~��p��34?PB8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���Z8��z���3���-�a��������-�a��������-�a��������-�a��������-�a��������-�a��z0Bz0�#�`��z0Bz0�#�`��z0Bz0�#�`���z0ЃY=�=�Ճz0ЃY=�=�Ճz0ЃY=�=�Ճz0ЃY=�=�Ճz0ЃY=�=�Ճz0ЃY=��ЃY=��ЃY=��ЃY=�!�ЃY=�1�ЃY=�A�ЃY=�Q�ЃY=�a��h�`��IBf�`�JBf�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��`VF��@f�`��6Z=�z0�#��@f�`�����Ѓ=�Ճzp��z0B�`VF������=8ЃY=�z0�#��@f�`�����Ѓ=�Ճzp��z0B�`VF������=8ЃY=�z0�#��@f�`�����Ѓ=�Ճzp��ϣzp���zp��O�zp�Ï�zp��Ϥzp���zp��O�zp����R����ϥzp���zp��z0B�`VF������=8ЃY=�z0�#��@f�`�����Ѓ=�Ճzp��z0B�;�#��@f�`�����Ѓ=�Ճzp��z0B�`VF������=8ЃY=�z0�#��@f�`�����Ѓ��R@b��x���q��*����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8Á3�u�#����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8Á3�u�#����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8Á3�u�#����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8Á3�u�#����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8Á3�u�#����:��p�g��g8p���p�38�Yg8���3��p��p�g8�G8��`�u�#����:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8Å3�u�#����:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8Å3�u�#����:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8Å3�u�#����:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8Å3�u�#����:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8��w�:��p�g��g�p���p�3\8�Yg8�.��3��p��p�g8�G8Å3�u�#����:��p�g��g�p���p�3\8�ċߗ�K�K���3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3\8�]g��.��3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3\8�]g��.��3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3\8�]g��.��3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3\8�]g��.��3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3\8�]g��.��3\��p��p�g��W8Å3�u�+����:��p�w��
g�p���p�3���H�/��J���|���������p�5<_`�ņ+���K�6\���j��
nx��V�Wx���Zp��/�֊��`��]r���S���p�9<�Xk��
txN�֪���b�e�+��9�Z�W��s������k�<\!�)�Zz���S���p�=��p����k�>\��)�Z~���S���p�?<�Xk�
�xN��
��b�%�+�9�ZkW�s��!�@��k�B\��C�e�+�9�Z�W8�s��"����k�D\!�)�Z���"�S��q�E<�Xk1�
�xN��j��b��+8�9�Z�Wx�}��� qH<�XkE�
�xN�֒�$�b�5�+L�9�Z�W��s��V%�P��k-K\��)�Z���%�S��0qL<�Xke�
��h�.M\Aϩ���w�����f�ު��������Ϳ7L�V-�`��Q���m��i��j3$�g��}%n��'{�VC4|�*�W�o�������1�&���n��Y<��͸�@���wl��b7�n.�[�f�M��s�݌�	�xn��q7��-v3�& �>臏q7A�-vs�&��n��c<��͹�����9w���b7�n3�[���Mp�s�ݜ�	�xn��s7A�-vs�&P�>(��s7��-v�&`��n��m<��-������w���b��n8�[��M�s�݂�	�xn�[p7��-v�&��>h�Op7A�-vK�&���n��w<��-�� ���%w���b��n=�[��M��s�ݒ�	�xn�[r7A�-vK�����$wS�a��Oq7����wS�a��Oq7 ���wSb��Oq7E ���wSb��Oq7� ���wS
b��O    q7� ���wSb��Os7!���4wSb��Os7E!���4wSb��Os7�!���4wSb��Os7�!���4wSb��Os7"���4wS"b���p7E"���wS&b���p7�"���wS*b���p7�"���wS.b���p7#���wS2b���p7E#���wS6b����n
Gq�9�M�!.>��)1���p7�#������ݔ���s��"C\|wSFb����n
Iq�9�M)�!.>��)&1���r7�$���\���ݔ���s���C\|.wSVb����n
Kq��Mi�!.>��).1���r7�%��@���}������!��j7ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%��0z�)/1ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%��0z�)/1ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%��0z�)/1ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%��0z�)/1ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%��0z�)/1ą�KLy�!.�^b�Kqa�S^b�����C\�Ĕ����%���F/1�%���Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��0z�)/qą�KLy�#.�^b�Kqa�S^�����G\�Ĕ�8���%���F/1�%��@���}������!��j7ą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��pz�+/qą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��pz�+/qą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��pz�+/qą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��pz�+/qą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��pz�+/qą�K\y�#.�^��Kq��W^�����G\8�ĕ�8���%���N/q�%��8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��pz�+/	ą�K\yI .�^��Kq��W^�����@\8�ĕ����%��$N/q�%��@���}������!��j7�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%��zI(/	�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%��zI(/	�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%��zI(/	�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%��zI(/	�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%��zI(/	�E�KByI .�^�Kq��P^������@\�$���"�%��$A/	�%���$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%��zI(/I�E�KByI".�^�Kq��P^�������D\�$��$�"�%��$A/	�%���gw{���-���%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%��$߸����|�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K�zI*/�7.�%���޸����z�^��K
q���w�/i~���2{�vC\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^R������B\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^R������B\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^R������B\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^R������B\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^R������B\������%���E/)�%��(zI)/)�E�KJyI!.�^R�K
qQ��R^��N�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�����F\����4��%���E/)�%��(zI)/i�E�KJyI#.�^R�KqQ��R^҈�̿�7i~���2{�vC\4����4��%���M/i�%��hzI+/i�E�KZyI#.�^��Kq���V^҈�����F\4����4��%���M    /i�%��hzI+/i�E�KZyI#.�^��Kq���V^҈�����F\4����4��%���M/i�%��hzI+/i�E�KZyI#.�^��Kq���V^҈�����F\4����4��%���M/i�%��hzI+/i�E�KZyI#.�^��Kq���V^҈�����F\4����4��%���M/i�%��hzI+/i�E�KZyI#.�^��Kq���V^҈�����F\4����4��%���M/i�%��hzI+/i�E�KZyI#.�^��Kq���V^2�N�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2������A\4������%��dM/i�%��hzI+/�E�KZy� .�^��Kq���V^2��̿�7i~���2{�vC\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^2������A\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^2������A\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^2������A\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^2������A\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^2������A\�d���b�%��dC/�%��z�(/���KFy� .�^2�Kq1��Q^r𝡗�򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸z�(/9�����򒃸@���}������!��j7�š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�^r���š��%qq�%Gy�A\z�Q^r�C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".��(/���C/9�K.���K�򒋸8�����".2�nߤ�}�o���qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��\�ť�\�%qq�%Wy�E\\z�U^r�^r��8^�!���w{n���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/����K�����K�����K�����K�����K�����K�����K�����K�����K�����K��� ..��
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/����K�����K�����K�����K�����K�����K�����K�����K�����K�����K��� ..��
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/yn���
/����K�����ސyo�%��[�{Cfo�nO\�!��j�'.ސ�[��o���퉋7d�V����2{�v{����U�=q��ުݞ�xCfo�n�݌�	/yn��q7�%�-v3�&���n�݄�<��͸����w^��b7�n�K�[�f�Mx�s�݌�	/��`7�n�K�[���Mx�s�ݜ�	/yn��s7�%�-vs�&���n�݄�<��͹����9w^��b7�n�K�[���Mx�vs�&���n�݄�<��-�����w^��b��n�K�[��Mx�s�݂�	/yn�[p7�%�-v�&���n�݄���b��n�K�[��Mx�s�ݒ�	/yn�[r7�%�-vK�&���n�݄�<��-�����%w^��b��n�K�[��My����2{+v�v+�>ح����`��n�K�݊�)/�v+�>ح����`��n�K�݊�)/�v+��wS^b�ݚ�)/1�n�ݔ��a��n�K̰[s7�%fح���3���My�vk��5wS^b�ݚ�)/1�n�ݔ��c��n�Ḵ�p7�%��m���s�6�My�9v��wS^b�݆�)/1�n�ݔ��c��n�K,��p7�%��p7�%��p7�%��p7�%��p7�%��p7�%��p7�%��p7�%��p7�%��p7�%���p7�%���r7�%���r7�%���r7�%���r7�%���r7�%���r7�%���r7�%���r7�%���r7�%V��r7�%/A����+q�o���^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy��K�^b�K^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy��K�^b�K^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy��K�^b�K^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy��K�^b�K^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy��K�^b�K^b�S^b��������Ĕ����%����%F/1�%/1z�)/1x��KLy���Ĕ�8���%����%F/1�%/1z�)/qx��KL    y��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/1z�)/qx��KLy��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/1z�)/qx��KLy��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/1z�)/qx��KLy��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/1z�)/qx��KLy��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/1z�)/qx��KLy��K�^b�K^b�S^���������Ĕ�8���%����%F/1�%/A����+q�o���^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\y��K�^��K^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\y��K�^��K^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\y��K�^��K^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\y��K�^��K^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\y��K�^��K^��W^��������8�ĕ�8���%����%N/q�%/qz�+/qx��K\yI|��ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/qz�+/	x��K\yI�K�^��K^��W^����򒀗8�ĕ����%��$�%N/q�%/A����+q�o���^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI�K�^�K^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI�K�^�K^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI�K�^�K^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI�K�^�K^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI�K�^�K^��P^𒠗�򒀗�$���$�%��$�%A/	�%/	zI(/	xI�KByI~��$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/	zI(/IxI�KByI�K�^�K^��P^�𒠗�򒄗�$��$�$�%��$�%A/	�%	/A����+q�o���^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI�K�^��K^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI�K�^��K^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI�K�^��K^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI�K�^��K^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI�K�^��K^���T^�𒤗�򒄗$�$��$�$�%��$�%I/I�%	/IzI*/IxI�KRyI}��$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/IzI*/)xI�KRyI�K�^��K
^���T^R𒤗�򒂗$�$���$�%����%I/I�%/A����+q�o���^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�K�^R�K
^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�K�^R�K
^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�K�^R�K
^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�K�^R�K
^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�K�^R�K
^R��R^R𒢗�򒂗�������%����%E/)�%/)zI)/)xI�KJyI�����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/)zI)/ixI�KJyI�K�^R�K^R��R^�𒢗�򒆗����4���%����%E/)�%/A����+q�o���^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZyI�K�^��K^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZyI�K�^��K^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZyI�K�^��K^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZyI�K�^��K^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZyI�K�^��K^���V^�𒦗�򒆗4����4���%����%M/i�%/izI+/ixI�KZy��o���m�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/xI�KZy��K�^��K^���V^2𒦗�򒁗4�������%��d�%M/i�%/izI+/x	B��-^�[�{Cfo�n𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KF    y��K�^2�K^2��Q^2𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KFy��K�^2�K^2��Q^2𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KFy��K�^2�K^2��Q^2𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KFy��K�^2�K^2��Q^2𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KFy��K�^2�K^2��Q^2𒡗�򒁗�d���d�%��d�%C/�%/z�(/x��KFy��K�^2�K���KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ��d��x��KFyɁ� d��╸��7d�V�/9���ˇ��Ȳ#A��n:~dp���~h�Ɣ�)���%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�򒵗,y��K�^��%+/Y{ɒ���d�%K^�~��^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���o�l���!�n�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����KxI��{��m��o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^R?�g/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��~�%�^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxI��K��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<����<{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�#/y��^�m���!��}�6��2[�����ߖ�}���!�n�q�{��m��w\�2[�����ߖ�}���!�n�q�{��m��w\�2[�v�-���۪[�xɷU�p7�o�n�n�%�V����K�������|[uw/����^�m�-���~������|[uKw/����^�m�-���۪[�xɷU�t7�o�n�n�%�V����K�������|[uKw/��U�t7�o�n�n�%�V����K�������|[u+w/���V�^�mխ���۪[�xɷU�r7�o�n�n�%��ԭ���۪[�xɷU�v7�o�n�n�%�V����K�������|[ukw/�����^�mխ���۪[�y�����!�n�n�n�%�n�n�%�n�n�%�n�n�%�n�n�%�n�n�%�n�n�%�n�n�%�n�n�%�6�F^�n���K"���yI��w#/�P��n�%�v܍�$Bݎ���D��q7�u;�F^�n���K"���yI��]w#/�T��n�%��vݍ�$Rݮ���D��u7�Hu��F^�n���K"���yI��]w#/�R��n�%Q��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%���܍�$Zݞ���D��s7�hu{�F^�n���K����yI��=w#/�V��n�%���܍�$Fݞ�����D��[�`��~��-u����$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$��^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^��2�m��m��=d���M^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I��Q7{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$y    I�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�Kt�����������R7yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����K�G��%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/�!��V/���C�oK��%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/�u��4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I����D��[�`��~��-u����d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K�������d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/�!��V/���C�oK��%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ������!�nW^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\y����z�6��2[�&/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗쏺�K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��K��䒗����K.y��Kt�����������R7y��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d    �KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�Kޏ��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y�2�m��m��=d���M^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�/i�������m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K�G^��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗���KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/�yɳ�<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�?�g/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%���%�^��K�m��=d~��/���C�oKݾ������R�ї?/�}�v��2[�����ߖ�}���!�n�q�{��m��w\�2[�����ߖ�uw/����^�m�-�����K�xɷU�p7�o�n�n�%�V����K�������|[uw/韫n�n�%�V����K�������|[uKw/�����^�m�-���۪[�xɷU�t7�o�n�n�%�V����K�g�-���۪[�xɷU�r7�o�n�n�%�V_���K�������|[u+w/���V�^�mխ���۪[�xI�<u+w/�����^�mխ���۪[�xɷ՗v7�o�n�n�%�V����K�������|[ukw/�����F^����{��m�[��۸yI��۸yI��۸yI��˸yI��۸yI��۸yI��۸yI��۸yI��۸yI������D��q7�u;�F^�n���K���q7�u;�F^�n���K"���yI��w#/�P��n�%��v܍�$Rݮ���D��u7�Hu��F^�/���K"���yI��]w#/�T��n�%��vݍ�$Rݮ���D��u7�(u[w#/�R�u7�(u[w#/�җu7�(u[w#/�R�u7�(u[w#/�R�u7�(u[w#/�V�u7�hu{�F^�n���K����yI��<w#/�V��n�%���܍�$Zݞ���D��s7�hu{�F^�n���KB^�C濭^�����ߖ��K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^򒰗yI�K�^�%!/	{I����$�%A^�?�f/	򒔗��$�KR^�� /IyI�K��$�%a/	򒔗��$�KR^�� /IyI�K��$�%a/	򒔗��$�KR^�� /IyI�K��$�%a/	򒔗��$�KR_�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/�!��V/���C�oK��%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/�u��$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%�/i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��$�KJ^���$/)yI�K����%i/I򒒗��o�l���!�n򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I������%E^R򒲗yI�K�^R�%%/){I����K����%e/)򒖗����KZ^R��"/iyI�K����%e/)򒖗����KZ^R��"/iyI�K����%e/)򒖗����KZ^R��"/iyI�K����%e/)�֗��yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�    K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�Kt�����������R7yI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����K�G��%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%m/i򒑗����KF^���&/yI�K��d�%:d������{��m���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%#/{ɐ���d�%C^2򒱗y��K�^2�%�G��%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9�2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/�!��V/���C�oK��%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ��#/9��C^r�%�^r�K����Kyɑ�{�!/9�c/9�%G^r�%����K��䐗yɱ������!�nW^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K��{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/9��C^r�%�^r�K����Kyɕ�{�!/��c/9�%W^r�%����K��䐗\yɱ��+/�!��V/���C�oK��%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\�+/���K^r�%�^r�K����K.yɕ�\{�%/��k/��%W^r�%����K��䒗\yɵ�\��Q7{�%/Yyɵ�\򒕗\{�%/Yyɵ�\򒕗\{�%/Yyɵ�\򒕗\{�%/Yyɵ�\򒕗\{�%/Yyɵ�\򒕗\{�%/Yyɵ�\򒕗\{�%/Yyɵ�\�՗k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/���K^��k/��%+/�!��V/���C�oK��%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/Yy��K��d�%k/Y򒕗��d�KV^���%/y?�f/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,y�ӗ��,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y��K����K�^��%O^���%/y򒵗,yɓ���d�K��d�%K^��%k/Y�'/Y{ɒ�<y����z�6��2[�&/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^    ��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䑗<yɳ�<�'/y��G^��%�^��K����Kyɓ�<{�#/y�g/y�%O^��%����K��䁗�޿�����w���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�#/y��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K�G^��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗̏���KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^�m��^��K����KxɷU7{�/�yɳ�<�o�n��^�m��^��K����KxɷU7{�/���f/y�%�V��%��۪��䁗|[u��<�o�n��^2?�g/y�%�6��2���l���!�n�q�{��m��w\�2[�����ߖ�}���!�n�q�{��m��w\�2[�����ߖ�}���!�nG����K�������|[uw/����^�m�-���۪[�xɷU�p7�o�n�n�%�V����K��[�xɷU�t7�o�n�n�%�V����K�������|[uKw/����^�m�-���۪[�xɷU�t7��YuKw/���V�^�mխ���۪[�xɷU�r7�o�n�n�%�V����K�������|[u+w/���V�^2?O����K�������|[ukw/�����^�mխ���۪[�xɷU�v7�o�n�n�%�V����K�������|���2[�?�6�F^?�6�F^?�6�F^?�6�F^?�6�F^?�6�F^?�6�F^?�6�F^?�6�F^�n�n�%�v܍�$Bݎ���D��q7�u;�F^�n���K"���yI��w#/�P��n�%�v܍�$Rݎ���D��u7�Hu��F^�n���K"���yI��]w#/�T��n�%��vݍ�$Rݮ���D��u7�(u��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%Q��F^�n�n�%���F^�n���K����yI��=w#/�V��n�%���܍�$Zݞ���D��s7�hu{�F^�n���Kb���yI�Kt�����������R7yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�KB^�� /	yI�K��$�%a/	򒐗��$�K�G��%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/	{I����$�%A^�򒰗yI�K�^�%)/�!��V/���C�oK��%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/IyI�K��$�%i/I򒔗��$�KR^���$/�u��$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����$�%I^R򒴗$yI�K�^��%%/I{I����D��[�`��~��-u������KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K����%e/)򒒗����KJ^R��"/)yI�K�����^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^�򒲗yI�K�^R�%-/){I������%E^��2�m��m��=d���M^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i򒖗����KZ^���&/iyI�K����%m/i��Q7{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K    �^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��K�^��%#/i{I������%M^2򒶗4y��Kt�����������R7y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KF^2��!/y��K��d�%c/򒑗��d�KΏ��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%C^r�%c/�#/{ɐ�y��K����K�^2�%G^2��!/9򒱗yɑ���d�K��d�%�>���&X�����4��ʿ�����{�C�47�M	9�I���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/��o��l���!�u�𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/���~�����xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%��p����e������ۺnxI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%����������%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/��o��l���!�u�𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/���K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^�!�ߖ��ƿ�C�o��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��5^R���������M^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�/Yy�/��t����oK7y�/��t����oK7y�/��t����oK7y�/��t����oK7y�/��t������KV^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�-��%k��~𒕗��oK7y�/��t����oK7y�/��t����oK7y�/��t����oK7y�/��t����oK7y�/��d�%k����M^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�-��%k����M^��K�/Yy�/�����!��}�m��=d����w\�2[��;.~����������u����C�o�}���!�uݾ�����ۺn�q�{��m]���=d���[�����oK��n�K�-ݎ�/��t;�f��������oK��n�K�-ݎ�/��t;�f���������i�u3^�m��f����-��xɷ�[���oK�P7�%ߖn�n�K�-�B݌�|[���/��tu3^�m��f��~�n�n�K�-ݮ�/��t��f��������oK��n�K�-ݮ�/��t��f��������    �oK��n�K�-ݮ�/����U7�%ߖnO݌�|[�=u3^�m����xɷ��S7�%ߖnO݌�|[�=u3^�m����xɷ��S7�%ߖnOݜ�|��=d������[����C�T7�%�n�n�K��Rݜ�����9/9?tKus^r~������-��y���[���s�������9/9�n�n�KΡ[���s�V������9/9�n�n�KΡ[���s�V������9/9A�R7�%'������Zݜ���[���tkus^r�n�n�KNЭ��y�	���9/9A�V7�%'�����\���9/9�n�n�KΥۨ��s�6���\���9/9�n�n�KΥۨ��s�6���\���9/9�n�n�KΣۨ�������<���9/9�n�n�KΣ۪�������<���9/9�n�n�KΣ۪�������$�Vݜ���C�-/�������u�K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K^r�%�y��K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K^r�%�y��K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K^r�%�y��K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K^r�%�y��K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K^r�%�y��K���8/9xɑ��%/9����%G^r�����K�󒃗y�q^r�#/9�K�n��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$�#/9�K/9��$������6��2[�/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���KB^�K/	yI8/	�$�%�$𒐗���C7yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�p^r񒐗�󒋗��$��\�$�%���%!/	�%/	yI8/�xI�K�y��KB^�K.^�!�ߖ��ƿ�C�o��%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%/�����%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%/�����%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%/�����%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%/�����%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%/�����%W^r��\���K�󒋗\y�u^r�+/��K.^r�%�y��K���:/�xɕ�\�%�n����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗\y�u^��+/��K^r�%�y��K���:/yxɕ�\�%/�����%W^r��<���K�󒇗p����e������ۺnxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�y��K���9/yxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�y��K���9/yxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�y��K���9/yxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�y��K���9/yxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�y��K���9/yxɓ�<�%/y����%O^�<���K�󒇗<y�s^��'/y�K^��%�yI��M^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^��%�yI�%O^�$^�!�ߖ��ƿ�C�o��%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^�xI�K�yI�%)/I�%����$��$^��t^R?t�����KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%� �  �𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)�$�%鼤𒔗���KR^��K
/IyI:/)��C�-/�������u�KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%弤𒒗���KJ^R�K
/)yI9/)���%�����=d���[�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^R�r^�xI�K�yI�%%/)�%�������4^�!�ߖ��ƿ�C�o��%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^�xI�K�yI�%-/i�%�������4^��v^2?t�����KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/���%��d𒖗���KZ^��K/iyI;/��C�-/�������u�KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d𒑗���KF^2�K/y�8/�d�%�d�&/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x��K�y��%#/�%����d��,^2�q^�x	��[^f�~���놗��d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�y��%+/Y�%����d��,^��u^�x��K�x	��������}�&/Y�%߇n�5^�}�&/Y�%߇n�5^�}�&/Y�%߇n�5^�}�&/Y�%߇n�5^�}�&/Y�%�����d��|[��K�xɷ���d��|[��K�xɷ���d��|[��K�xɷ���d��|[��K�xɷ���d��|[��K�xI��%+/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�?x��K�xɷ���d��|[��K�xɷ���d��|[��K�xɷ���d��|[��K�xɷ���d��|[��K�xɷ���d���^��5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%ߖn�5^�m�&/Y�%�����d����՟��ߔ������������������k��      M   <   x�31�445506��Upvtq�s�21���p��y+ E\}#���b���� p��      O      x�34�p�����       P   �   x�m�An� E���@� �$��1!$20��z�s��h*u�=[�BJ9�3��كō��τ���C��q��J\�����L�`�"H��l��/���{s�W| CGt�?���͝%`�ɑ7TN0�м��Ck���vN�3���E�!!��5�..5�xګ��� ;x5@>� �:G�-��<����x@�>�[�=;C6��� �-�Vݻ`���ڑ�R�rN�¦^�'BS񟿺�˺�m�4_'�b+      S   4   x�3�t�t�Spr�U�LL��̃��\������A��ũE+F��� ��      W   9   x�3�tt����tL����,.)J,�/�2�v�H�KO/�KTp�L,N����� u��      Y   V   x�e�;�0�ھKЮ�S�������4�<� `��D$�x�qe�1���Rj?�x�	=����]`
C�/`\���c��      Z   <   x�-���0�7UL`��^�� ��N84��Y�l����X���Kj~OD��z      ]   R   x�e�1�0�9�K����K���%Z��g�`$��9�	�W�¡|�C+����me���/�Ӎn����qK0�����'      ^   ?   x�-��� ����H���� ��X#Kk�Y?�+#�2S�/��򌉠ʃ�����#i��      a   6   x�346�400�FF&���F��������\��f`93�����!'X&F��� 4�	�      b   &   x�34��446�45�4�24�r�8M�8M�b���� S��      e   H   x�U˻�0�x���y%B�@J���@:@:O����5܇9��f����R��˦�{��F�(�k�>H>���      f   G   x�e��� ��0��0E'`�9hAU}�t>�C�ƅp2����T�$c����[js'<?��ߓ��5�     