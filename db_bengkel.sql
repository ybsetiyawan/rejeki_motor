PGDMP  (        	            }         
   db_bengkel     16.4 (Ubuntu 16.4-1.pgdg20.04+1)     16.7 (Ubuntu 16.7-1.pgdg24.04+1) �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
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
    public          postgres    false    217   Ѩ       }          0    17133    m_item 
   TABLE DATA           c   COPY public.m_item (id, kode, nama, id_satuan, id_jenis_item, stok, hpp, aktif, modal) FROM stdin;
    public          postgres    false    219   6�       �          0    17142    m_jenis_item 
   TABLE DATA           6   COPY public.m_jenis_item (id, kode, nama) FROM stdin;
    public          postgres    false    222   I,      �          0    17147    m_satuan 
   TABLE DATA           ,   COPY public.m_satuan (id, nama) FROM stdin;
    public          postgres    false    224   1      �          0    17151 
   m_supplier 
   TABLE DATA           J   COPY public.m_supplier (id, kode, nama, no_hp, alamat, email) FROM stdin;
    public          postgres    false    225   >1      �          0    17158    m_user 
   TABLE DATA           J   COPY public.m_user (id, pegawai, username, password, id_role) FROM stdin;
    public          postgres    false    228   �3      �          0    17166    role 
   TABLE DATA           .   COPY public.role (id, kode, nama) FROM stdin;
    public          postgres    false    232   b4      �          0    17172    t_retur_receipt 
   TABLE DATA           Y   COPY public.t_retur_receipt (id, no_retur, tanggal, id_supplier, keterangan) FROM stdin;
    public          postgres    false    234   �4      �          0    17179    t_retur_receipt_detail 
   TABLE DATA           T   COPY public.t_retur_receipt_detail (id, id_retur_receipt, id_item, qty) FROM stdin;
    public          postgres    false    235   �4      �          0    17184    t_retur_sales 
   TABLE DATA           W   COPY public.t_retur_sales (id, no_retur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    238   �4      �          0    17190    t_retur_sales_detail 
   TABLE DATA           P   COPY public.t_retur_sales_detail (id, id_retur_sales, id_item, qty) FROM stdin;
    public          postgres    false    239   5      �          0    17195    t_trans_receipt 
   TABLE DATA           [   COPY public.t_trans_receipt (id, no_receipt, tanggal, keterangan, id_supplier) FROM stdin;
    public          postgres    false    242   5      �          0    17200    t_trans_receipt_detail 
   TABLE DATA           N   COPY public.t_trans_receipt_detail (id, id_receipt, id_item, qty) FROM stdin;
    public          postgres    false    243   S6      �          0    17205    t_transaksi 
   TABLE DATA           V   COPY public.t_transaksi (id, no_faktur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    246   �7      �          0    17210    t_transaksi_detail 
   TABLE DATA           c   COPY public.t_transaksi_detail (id, no_faktur, id_barang, qty, harga, subtotal, modal) FROM stdin;
    public          postgres    false    247   �7      �           0    0    faktur_sequence    SEQUENCE SET     =   SELECT pg_catalog.setval('public.faktur_sequence', 5, true);
          public          postgres    false    215            �           0    0    kode_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.kode_sequence', 2, true);
          public          postgres    false    216            �           0    0    m_customer_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.m_customer_id_seq', 2, true);
          public          postgres    false    218            �           0    0    m_item_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_item_id_seq', 4094, true);
          public          postgres    false    220            �           0    0    m_jenis_item_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.m_jenis_item_id_seq', 156, true);
          public          postgres    false    221            �           0    0    m_satuan_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.m_satuan_id_seq', 2, true);
          public          postgres    false    223            �           0    0    m_supplier_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_supplier_id_seq', 14, true);
          public          postgres    false    226            �           0    0    m_supplier_kode_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_supplier_kode_seq', 14, true);
          public          postgres    false    227            �           0    0    receipt_sequence    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.receipt_sequence', 25, true);
          public          postgres    false    229            �           0    0    retur_receipt_sequence    SEQUENCE SET     D   SELECT pg_catalog.setval('public.retur_receipt_sequence', 1, true);
          public          postgres    false    230            �           0    0    retur_sales_sequence    SEQUENCE SET     B   SELECT pg_catalog.setval('public.retur_sales_sequence', 1, true);
          public          postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 3, true);
          public          postgres    false    233            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.t_retur_receipt_detail_id_seq', 1, true);
          public          postgres    false    236            �           0    0    t_retur_receipt_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.t_retur_receipt_id_seq', 1, true);
          public          postgres    false    237            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.t_retur_sales_detail_id_seq', 1, true);
          public          postgres    false    240            �           0    0    t_retur_sales_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.t_retur_sales_id_seq', 1, true);
          public          postgres    false    241            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.t_trans_receipt_detail_id_seq', 51, true);
          public          postgres    false    244            �           0    0    t_trans_receipt_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.t_trans_receipt_id_seq', 25, true);
          public          postgres    false    245            �           0    0    t_transaksi_detail_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.t_transaksi_detail_id_seq', 89, true);
          public          postgres    false    248            �           0    0    t_transaksi_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.t_transaksi_id_seq', 3, true);
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
       public          postgres    false    3270    232    228            {   U   x�3�4000�r�r��T���⌀ N/GG?o� G?w_W?/ ���+��Z�����i`ahdlbhhjjj����� ���      }      x����r#9-���z����%^��|۲��U�-�$��;����"@$S����V��u @�[g���������1�g:�Y�+�N���w����[����<����I����ɷ6<��S�����y��W.�,ws[�L��w�}wy?�w�����e�?ޞ�������Ӕp�pQ�^ޟ�����m�z�_��1[�����_R���[7͓���Rc��?����o}.�&��S�K�?]JK�{W�ta^�/}���y?�ܟ��˝�&�)@�1!~�.��$�es5��a�%(Tm?�7����f��~^�� �����'N�U��l﬙J[&���d�����sAX��SA�F��:�y<��^O��uw�{:��7��������f�P�Kq~�\>�i�~m�㛇��y���>a���#S��ʳ43������4ݕ��ʷT����6����_:��1ކ���q�~>1��FƉ�����?���n���a�ׯ����ح1=��&�.�m�sh;7(�4�mNCS�;N���������)chf�-_��v��6ԲÜ�/8�dHS*c8���\M�����xG.{BO�������isݿ=�7?v��isx{<���W�D�����VF��~ǈ�Q��<B��L��.V���!�z������HS�{�*�
r��|y�.^^w����.I��n$�L�ﷷѷ`�oF�gI1)�]l^�2����4y3ût~�vȜe���L�x���8mv�u
<+2��K'H������ I�
I~���pz�@�4���K�?�����ˏߛ��@_Gp��b�8�>j���(97K��e)ΧG����������[4�+q��AE�-4�E�ɀG̚Y��	c��ɓ1��2K�oQ4�81�[D���۪fX�1�.��j(K�T���r��H��p��{������ya�JXi��t1cGD�p����1�s=<���w��d��xܿ��y��2�yE�z!V�m��=�@���e�!��Ϛv�Lx�P�v��o7_�p�A�.���:XQL�(����{@R_	����Hb@�Z𓨑��l��B�e���'ɢ�E��Bl�ԧ���u�liXӅ0@TQN�+���HBH�
56,�{�7�����/��Y���7��7_H��#�h������ŏ��ڭ����ټ��)���0[��f; ��_����CH���U�Z�����|x+���&N�Lhy?.��l8M�*�����}�p-��Z�sj"M�9o	uϬ�Y��3��YOv�eƛ!��5��yY����������Q�9������Ti2@��6-��i�TԀ����r�`�	!�7B	L��l���
�k+$��L�#ɷCVAi��DL�	*�}i��K��0��G�U!eTd����-i�"��yՊ\y��0ď;̗�z����H!0��w9}�&�j�3�E�l�&����,
�0�lE� �񖖘��ʽ����B��L�S�����H��*r���B�Ǣ�8��P9���|Z	����=�/�͕�
���n�ʸ�"���+b�	���.w��_7D��q����m��$D���uKp��y�K`�@j?��B�0��{*��2[ߺ���ЍJ]v9@���Œ}e�K��%�{��m��'w�r-�-�,)�f��ץ�G�f�a��wI۷�(��ҵz�P��f%�Y��$� �ήú��U�l�1��Op~8?��3^�J�K�+vE�Û�י�n�)��=*liK
�Żu<1.�ﲼ�)&��o�2~����k2o�������c^sXl��։f�f���t=|�\ϻ��2�շ��(�6��e�Ƹ�iR�~�m��'����J�^0ǘL,SZ��)�5�bh���y�֦��G������c�Q�dX��Z��,��d&��*�D!�l:�i�����y �X-M	��K%D��C	ԮD�y �T�� �"h�Ͳ���	ىȇȤ&Qs���TB����V����qk6�ى��@�wlo���?��[�8o�����������b�D�V/6F�X���]��.ޖ�U����(g��Q� ��(�!9�-�!���}� �C*�F�η
�o�j c[m�KA�P7C�"��.kC�Iگi�NL,�|�����e�׸�D�#�pd�-�s�*��ޜ�� G�2<��b�%&�g�֥��w�+�,�M���_�k���=��f�������Y�4.s���x 6��>Ϯ�K�4w�W0L�i�ݢ���ٲ&�"���]�Ĭ�&+j�7��4�]�D'�Ҍ}�]��虼Ǳ>��a�[�zFO �:�d�9Әx�ֲ<hT�"-s�O'�z=A"���6�BunNje��`������*m 茽����9�7� ꀑ2J2b�����^xs>=���C<I�sZC���Ñ0 ��෤�Z�Ï��������d�SgV0�lb��nE!]�Q������[ 6U�v�ܧ�c���vχ����!�ޒF��jp��N�@+}h��B��&'��;���31f�̺�����w��2�q��H� ��<n��ϟ����i�I����>�j ѦBv=�v�$���=�y"_�u��5�h�F C�ؗ�ޟ.�#l��6,������)�a��+����<CE�mؚn����v�s�ŧ�QI��v�>7ND��pj�Nqg�C`�e4���z_˷�Y,w�x�Zꑼ�N�b[�jN�}��Ql����y=m��aSM�빎��}b���M���%^m���i�g�>��nUo����'P{Pݥ*,o��*J���J���Noდ
hz��{n�������y>72����u2lT;�0.�(_���K�u]�n[;����U�-�66VZ�c��6�s}����GSj���@(ɷ�߻���N �\��`� #6��J��g������"�_^�����n�s�u��s�8a6���~��=�z����F���a��mH��b��]�!����QCx��ί�p(�\c������F�^�%��x޹�Ҡ��ƑhNۧ��Vŗ!�'C�.������'��,�g���崩�렡X���r+�cZ��ŷ����
�mT�4\�Z.+�ä$��o!+�����i�������%2/��V��m���i�=���V7�ΚV��uֈf�Kg��h��W';��7�9�u-F���
��m���4*$(!��J&��N-�6�Xp��涡Ŵk�d]�@�Yc�-O	������ח��7|iџ�O��0��j���M�#��4sƴ�n¥=���+>K��?5���k?W�W[Ymd�9���kUG�k�B�l��	^�3���@T ӛ*��;@��J�</:2�Q����ͺE��M4�f� ׷�l�a���s�V>uܞ�4�*&lk�Tg�粿n��o�S;1��#�\�y���gu �Q�b|t{�Y��.�aw���J)�0�A2���r:>���r�����+\_/'�`]q_1^�N���q��xxA�̴��~9]3'���C��;�1C���"��G9�I�1%��}O����y�$�0mUF�l:�e��dE�:
�]d:8 ��*�])'\K
l�1���c�ew=v�o�i��=�ʈ'��12�����alA���M"-_N�GL���a�1��d7����DޓI����%�����@�r���Η��~�;~Kt��촹������s�Q�u'����-@�#�`��� ���TQ�![����1é�Zg�q�5�/,�[m��N�8�Q���>� v<h��w�d@:�a���촜�O/��cZB���J�!f���15*1E�DmrY����K̐�;0@Y���Ȍtp!fD���,�N'��#��]�(���0N��<h���;�w?��<:BN�=���B|�H�߼f߇�y��.V�fCu��ئ 0�B ����=�/R0R	�S��tp�$��?���|�����U;b\���y>?��<�r�+@�
�_�K����ڎ�1L��������>��Z    �4������" �~ar� j���t�֎��ln�ߴ��2��X-�lA#$j�]ғ����z:J�q�������ɋ���?4v���UB���p��� b��{��<?����W% m�	s��Y�_�����|�q喤���sp���Bu�J�LV���P ,8 ��{��޽|d`YG�>"���.@�Wa��\���-�Ev�t�!~��$�Ȍx|+�m�t��bS�V*������Y-�BtϢY��ױ�Kf���e��4���������g�f��z�玧`�*��$�)���d7_�_�O�/��E�e�Pgf�pA�۱�25�K�`sPi�
�տ�@}��n�P���u����X�<�D>�4��������$�A��;�|��?�o~ML�;�vpb}�g��.E�Z��
�6�J�$@$N�����}Ed �]��_�YO�GJ7c�8u���VB�cd��V����z�K�ؽ}�K86y~[K�x}tU-\V�TDgA<�u LJ�����Bh��Gkb��Ќĥ�H�Ηh�_'_��GH��PZ�n1�Ӷ��q��ѭL1;S%*�����kM��L5`�������&�3�(߻�5�i$��v�ûį��`�?����s��lz>���@W`����3����sB�4�,n�SB��b�Ӷ{��Rs$�꘢.���Ȳ.S�h��Ԉfs.�#��I.E����b|E���7b���!58�p���n�$�GT�)��c��f�MU�d����U�K�b����?��g���������m����큗�P����b_+й	�[��@PĜ���W���66xt�����͓��Z�������Lv�'ቯ�5��`H�[:Ob�6��{v�ҷ��j�R�O`�y|ۙA���.wJ`�y����l;�.h,[��Ӵ�������0�%�/��3O��������r yi�Um�uѤ�P�\+(�*W	l#�f��\�Cy�tL�|MSl��k%��Ad�Ish�Orj���r�|+����R�Z�$���H�+Y��C1�௯��Ef����W���K
F��#Kv�'y� ��X��%W1s�h�H�?�^�OD�yz��qۻZv��Ь�,}8��/b'��~�9�{]g����CN�S�A�� ���H�2F4q�r���c��U�x�����Z���:�|�Aْ$ĝ�I#�!��m�6��9-M7���jY�:��x"5E�f��*cEf�=�L�p)%@n���G��)� �L=��n �� �F0��s
�Ө1����3���a��7�Õ��[(�:����ݔ������+�vr��6�w��Z�X8��<:4�n��;eׁ��g.,&�b�ۥN�C:������yz����� ���
J�������'��{��!{�RͤvR��QC[M�{�F�DT���K���":��������F�<Jm˔�Dq�!��Ԁ���ft��	;�{5������G�V��~���c�[Dzq���7l�y������T���Ky��e*ɥ���TzV��X
G�Z��>	����J�����E�	�1Ϙln�LW�f	{�����o�Ǔj��F�n�uG��z8�b!m�O/ef�"��dM�*�ew�_��+JC��{�`��-���o�e�Pr��ͨ*�D����=�e8Mjl�v	�O�P|0�7���_��+{y����çqË뿦{��y�������K;��ˆ/���v�����pS�_z��\h]�PrM�=0$ō��)�z1\dV��ϳPԧHm2�|�u/��N�*�9�U��2���Cl�Yx��\G���a=w�[0�|h���l�@#u�w�����RS�!��
:;�fkL�M~ݝO0!.�|E@MR+��ܐ�z}yN��ՙ+��<�������J�+��RD�ُe�Ej�p����oLܘ	��#tqk%��s6��q�hg��˸�G��b�r<�-*�D:g�;����/�WJ	YD�p��y��X޼�^��%�w���<Y�J�y���Ĳ,K?�Q.q�\����N�#"�xd=����X/ Ӿg��#I���sI�նԬ�1�Σ���vi��2<�A�#�����z�^Z@K#楁���;�,����l�Xx��ZL��%E�6\ 1/�����=%u�㓢�OA
�Y�-`[i9�u�gbX�GlR)J	gW�?`��\+F^) q'x:��/��]�(;l`0�e{�EՄNh�~���<a�����%�,�TU�O1�Or�����Q�<2��}?\�9�-;5#]�XY��d�'�����'Q�தś����0� 4��T�Sya���Ã���^qr�qAp�.��5�[��s�PN�Y����;��r����{F��BK��=)��X��2�xF3��.�8]g�ޮ�s_M��}�럡�y�K�碛�˂�!��'��kE<a�WX�خ�QF��iJe8*í���h�d�u!�~���1"�=�0�'R�k�t���,~<n}�A�>��R�y]�<�n&<wyx���Ad�����;���0mc���$��ͷ���˅���[$�[���y��^�G�(oC� #� �����������h<�ɘ��ަ"	��o��"B�EHۈGƭ���?y<T�{0@��u�is>�Ʃ�3�s`2S��]�W���
m�&��E�;7Ms}�#\
��W�e�m��L2DG���g�p����sE�0�mt�:S���#��ހ~;�dRM��Tr�x׍������L�u�ڳP��tJ�W&�['�m���hqh�L4vn?/�0ܝh�m���R��+�q�K��֣�Ѣl�Wd�vǣ��0�qE��&c��!��x9�ɜ��2'��tuuʡGsW�D0Z��3LC������d�]�
�9v�v7��a�On�g����iZ�ْǉ����>�-����y�=@4���0ht#U:-}���h2�I/}^�jx�ng;�	N}�������4�o�ͮ�T�� �3���#�*u���kR�d6qyՐ�8���`22�t9�Sה����-�|�H�G���\ǽJ�F��˓-��	�\O��?�q�4ND*������GK�ȶ0B�؂y������A'�IA&���Ǐv�a�uc��P0���G�BCu%�3A�{Ƅ�܁0�h㵊�����]F���hȦe����
6�0�w��`?�ig��~ ��")�����y'S
%'�H}�f
u��1�h��X5Sp�6����߲�,�)��m[vw����O�QY�TS1�8T��D�M(����}w!�|�m���>lE@��Djmp��������*hKο_�/�����$��4L������mv�=l�p)��b�A��d�M!�9��m�\�& �B2�0��iL�钰B�nSP�m	Q'g��q�km"a�����R#݆�{�g��Y΃�$mo�Ͽ^$������4�|޿n�_KQc-(2���9#��,B^J���.�eCzb~8g���3B������v����&R���|}[?Af~��9�4�s���<�N��$�&R���	~g}��+P"i�-W�`n��ݚOh�ܼ�F�FBe���S���i�2My������|�0ڦho s��U 1+�5෦�6�z���`g��nRɐ������ѳ��N1� �p¶� `�1�7�e{=��mbT����@�=&6����
oi!�B�.�N��:��x�R�DK7F8����C/�d�I�L�����kr�K�,iqB�����������ޡ��wx����D�e��MC�(����3���T>=�.e��g_s��gS���%R+��)���_�į%6�zd�ra��"����G�E���{*�fN{Sqi�?�};9��ۅe*�i�`�҈�����q����β�A5h@��Hi�܀��Ǎ����&�Il ]w��E�-��a�4eB������������j ��u��c���q���|��b��� n���R6�v�I%ϧ�H�ٮ S̓	-8�"p<ͱ1�`u���3�b���-��U$ͷq+    H�L�r�Csm|�IA������K;�`�5ΤG�ߜ�J�yZ�tY�,M�Wږ��i��Y�V$�l|l楄4�y!�8����E�'��R���`�5h�*j�wI>�i""X36�x/o�hy{<X��S$�^�q�B�x�	8��Z�l��iq\#1�vLh�ys9R&���`;\^~oχ{5��8��`;� �q(@so�����~��j����
�����@Q'�O�m�Ɇ�ۥX���yx��`�Ij$9�v�ql�m@ �83�KX�����,㷲H��*��@�q��"���eW 9�
O�[����ÑNï�qN\�kc#�\ǥzaM��]އ�\ǥ�K�^G��/���n^E�@�d4%#��W��U�5�J�<��-�ߎ�uB��HאB�^�2��M�M�Ww�V>��=��@��i��������z�HF���@*'T�&�͖Z~���H���;gmr������i�o�����\7�+���
�k<�7:�N�E��i��o�Z�\��w�J"ʐ"*%q }ֳm3��@�Ӂ4Q��]y��-�Yԁ4�*^Bp���7��>���+K�2ڊd���,�|���M�W��K�P���̈���i�v���;D`�|\x���)6Cv�N[�����`=RZ��J�z�=��Dk@��e�\84��U}�ž?7���%e<�|��Ȥ�y:7��鱪��V>�̪�3�HFz�i�;�w��χ�������s���4�Y��$���k��_D���֩���@:���x�mWo�:��hٷ��������v���@.�v��c�A�s�HX؁�^�פ�ٞj��,�@ڮa�aR~�~3F͢0�l�@*�`�ȳ�J%�{�ȸ��
�׫���6��*���i�+Q���̺��_��!�
�F�z��7�Q�8d6�0�!�_�{����!���i��Ns�4�8'0Q&,���&J�s9����Kl18fhu�TL��J�%�̦ByE5?`�*�]��u��F`8�Yx�~x;H����\R0��,�՞��3�t�?���Maʔ7��ekc*aBr���i5G�%��B7��5�a
,�PT���R>l�,�<����U5֨�O\s<̱By���N��jdqe^*J�:�Ӭ��XG���H�~�![4�uJܜ�>G:�-�İ�C4Xh��tC��F"L��F��,���/@{���,@u'�ܺ� "E�U	�Du�l봺�v�f��=Q�GB�+����fx��3$Wi�����z���u��N+Hw�ñ��λ��ĝ{��-�v��&1�P�(.�%<���N�����_�80�^ ,�n����tݐM����.�v�ԇ�(�}X�*�7��V�
��٪G�5% Qk�x��a���¶���/~S�k9���+x���Hw=�Ylꧽ �*��.I��������"�_��:�YHyi ڷ˙����g�^Â�N{�=<n���P*��	���;�;�_���?|\囌<�T���S�/۟�z��=��r��R�IUuE�I�:�O/���5��3)0u8�?tcb���N4[Ö0t�΂�>��RУXa��߻�G��G̪ݼ"h�=�[)�B��^�sJ��}�KʈTF��Hw.3���J�V���ba����´�iV�N]?za=2gc����SRJ�~���a����,��)j��H�O`6n������}+$�~��4,�zX5�Z��z��i(x{-c��BӰP������Չ,E� ��qc*j9n$q�Į����CQ��<4?&��{����K�`Yn#�U�׋��A]BF>�i��p�֌Xހd�q7�Vpr�@CC�h�eP�n�T5�$�U0[ߋI������mY���j����~�2���?�P>*�I;�d+D6�lg�q��ƃ�N��|_�֡ZdЈ�PB'"��2�gW�P��LpF�������4��;b�˝��.��>�:����ܶ�=�]x,��ՙ�n�o8\��'.Qyu v��� z!�<����L���y��'c@���4*ou��Yٳ[z;.nM�3��g*�x����a���Q �W`dϤc��tBV����3i����3�B�K�A᤿w�4'Uт&�QA���Q���	9���NX��m�=��5�n�H��u�R5��f2�g�3ʜ:�ǧoߨ�o�H��=so�\�an����KBv���B��7���n��҈�H(����u�T1�e���e�B��/iK25.r�ǷQܨ$*[q��EL�� z> ^�u- ŗ|Rqn�
2λ��+�&�|�&R���ړ�]��<ܑ9^0R��4%��Lʤ��K�;B~��?�3H�Qy��K�k��؎$�{&e҂�O�7k!�z&]R ��K~(m���T�Ɣ+�Q��&�Y�3��<�Ud�
Rg�!�;8]Ȝ�I�$�C{����d� J|��p9w�F���p:��2��`f�L�����"�&��s�}����d|��yx��ɏ�0�gRHkX���#Sz&����h]g{��:�~��������IK5H���`3��,���jA���=�C����C\!m%����y'�|�P�`bi���`�8Sb&N$1�tN��h�@ԙC �����6/�$`��<��[�خ�}f���A����l�&$Z D�yi)8Fl�+ �Vp�쐒�OM�|���s4�{��O׳��JL�,2��h�_Oo�k�157�`�$���F�kwX�s���^�~�0Ď�%"(q�<|G8����D\<9���i�-�w��/�t����;M����qF��,@bF���*����C��|�ݓ	���`��qخs\H�v��G�����������-)U]6i��a���v,��6-*��Z�a�Ō�_�~+��$$���~B�gj����}^)�m��(Bz���9��s9�;יt���6�'�}���1����$��0Zg�;��L�V���E���A�GN�gވG�D�7��:��р�-#����^z��W�yux5}�5E�P��ʖ�KQ-/�+������=ST�n�d�FR..94n�D�"������C�/>G�eI�􀦖�	�)�IJ�#+��ฝ�S�%GR�I���
�p�M��c[�>ϗ�f��
�S�^w/{��i�$�H��Cb����Џ�,[2��vQ8ڮ��OH���8\k�]�VC9���Px��1�OdGcH�*��')�h�
��0�Y�6"�8��/�?{���)�n�E`��9R�Ʒ���l{4D �Lk���8�	k�//5�&u�\
�(c4e^��)Ԉ�ai�a�fL{w�im��s�X��hڤtк>34�v$�Z�on�;�d�E���v��q�V{qa�F��Ī��<�j��(�l�. ����=�f�4�]�)�Rv:�>�m�K���1��h��*S?r��s�q��$���g\�"v�eD�HT�K�#Qa��4�Ml��Idd�Fgp�N����"�7:; �Az��8��1&�7:M�|㿗+��+d�F�9#hd��Ծ#ĩ�a�F�I���b��2��������Nse��JD�"�`�F���O�%2k����4U�-{k;�#�7z͔8�Te�-ٹ�g������wO&\���؍ޮ����`�F�z���G��^��)3H6o��;�鴐V�$���>�g��|�I`�Va͌�3!"��W�7�0�L��� ��hudj�ji)�/lm3�.���?0��G���[�j�Q;��IS�$ѹ7u���8�D*�WM�0N�;z�q��-%*Pb�ԳH�����LL�z&U�7m�\�UJvr�z2e!�:����N���y�5+�\9��aX�q�i��lƗ������W��d;�)�
'ȫ*����e��
����F�%�C�rFC�N��҂e8����U�l`4#[wnb(���[������W�����f���"by�u�h�� �����Jk�i�*Xk��<`��'��G�
�f�*���^2�c��`6w�Н����v@�Qm�x�9ΚY���aG�    bĬ!�"��/?�1kF`�\p�Ջ����A`k�X �MD�ĝ�'��,��e�\�i ��z�,	��z0��8{��X0���n�Fj"�K;\�K.��`$���|~^�g_��c4#f�%�9M}����GM|t��F�b���G�j*��5
�8Ʃ&������dX�1�`�ڰ]dL�[>4�!��C��q�V'Ⲏ��K?��8��idWq�v�+��t�$�KK(�a�+u;���E��ܢE9�vq\\�l�S�����8b�Ҳ�F8ګ��%�f�'�,-Y.���a0ux��8.-ID��~�9�PJ��q�����j�k���q\�-����qi9#^R��.RQ�|���ݮ�s2����u:dzo�����[s���# [;B����;d�k�o,�fX����DOx���}QÝ���c�l�����{�{�9N h�	-C�a[���W`ʗP���Oe�HF󲍫؞�}�![��LN�Ĉ�"�y1-cX	7#���w�#�����j/˜�D�RG6��v��Y�Kr۾��C�Y:�7lKjf	����$�m�,�Azx��ʒ���%�o�
,��.����#�	X�K��6�d���R��5)���gw�w��v�laP/ɹ��׮n�� �zIN޶e��X�v��_2�+O0����mGS-�/r�����?��iP�� f��#"��#��ʝ�z��[�'��W�at/�;�����V(��ò�;ቐ�W�>��o�����L�!��IR�=x�ߘ�ݥg�ߴ�\�<k�2pa�<��&+|!ys�4Zep���_la!,�t`&�jE=Ku�>[�����*��MphOr���t?����3t!��]$W8a�/n��0��j&k|I>���u��x�����C�zsD8F���<�
�Y׾�����n�s-6e$MY�� ����������>�q�M-�F�|��x�\7���z�PQ̅�bRn�[�27��Zf���&ƹ�qEL~�{"�d��&"�'aE��?
��RfY �!?˧�0�o�������	yd�/�ޒ�vkL�Y�T:fY��k��n� &�y�%�ӱ��Fi�:�l��O��0ɐ�#$pD(F\��r8��B����dAl���{Ѷsu=�&�V"z0��ڏµx�N|������sG����L�er���������|����t==����I���O6�25�!K�Q|&�����ɴ���ݜleThN���������l��j�Wy��0O�%�zI�3�������\RJ^��I���St=Y�K�̎X��1�&��2���T2e��Q��� �zIY�� ey�X� ���h����X΍��^��e01!�g����T)�k����U�rÅ�_���%9g�>�p�mĚ�H4i3�KE0�ɐ^�o�"��WHա`@/�A�Ψ���9U<����ݑ���2�eC4%�b�+�|[��[��x1�����uQ^:E���'�������	�7����(1gJ��>ޮ9�X����]�JH��s���t�\���K,�kγa'/s�!�׹߽����[��˼�%F��v=�\^���� đhzH梮��$��D;T'gP�I��"�o��V^�[ͦN�u[�_�̯��+��%N�Y���6Mb�10eD�ݕ�����ā%y0Kef����$�s���J�ݹ�G�C�K��ХN7�I��da��'�B���aZVqe�\A�-2�iL���XHR�S15f�b�9�����h�(u��`�.��r�DUk�j�C˴�7{Y�n���e	���P7F�<��n¶����MG$p��H�p;����,#<�5U�m�f;��r���$ޕ��l_/���u?�Lj�0��-�y����o�t�K�Y��Ǥ�ҍ��?)XIi�Q��S�KTrQ%S0	ӻ$�L��4��R��7.�2����S%�)C��n�4�!,@j��V�0a���H
���{^�PP		m�]����[i�<\��� ��f�V[C�./1Ր/okL����JؒQ1�ۂ��A��I�>�	��"{R*B��A|���ڍ�7��iЁד�i�q�}��+C[}��*��Ҿl��y�I���f���і�̄O6�n����[)kk�e��7��5��V�_Z���[������ҭ��uO��OK�'����6�\wo/��fm4��'Ha:?����.���$opMlk}��l�R�-�0a��Ԃt� �2�3W����~%�����'���=l����Z6�0����3
TJ^៻k��k��-V	p�o�8��v;Zi���_��4ls��>���b����]rT��=ɜR�s��p�<�,�<`��������C-H�h��ë��U����K�&�p���=޿Ո�@8m�<Y`I#�u.H���l���һ��`ލ��Mh�"7׾���p��$Y�3(�� ��4��!���H��c��8[��8פ3,���,�K���!";E�	 �o�jG���-/O�����$���r�%f�
�Ђt�l���J�)WƃM~^��M2`݁/<�-,���ֺh�(��ꨤ�a8p����"�Ͳ��6bL�M�<m��78a��Sz�Y�mA�S�G�1;���ɵ����!
'l���'�π�-�W/7�Π��`ʠ�|��p'����;VL����>���|�Y�pU��R\s&V������Ǒ �%C���j9lb&,|Ĵe���4�ء�\�|�C\��k��)L�9rcE�B(TP�q��i�ˡ�6Je D(�(����y7ibS} ��H�q��}�၀sJϋ�+��F�,`D(�����C�@������)?!��A�'�P�d�������}�pE���n��S�!�����w?�W���UWWl�4����y����u��|Z��,�_��x�r������l��8A��=��W�n�J�IM��ɀ��������un"xb��\p�����Bmw���&'�T�ʆy-�e�$ �����A�.f�<��"p)߀�<+�6���9����)�.�s\��p,7�0 Yp(g�ڃ�i`r(�$c@��32	V�8��uց8f����h{t:���E��M�E�Dס�𯄫9�#ls{�v��S"엇�I�aJ:� �`@��3FS;Aʃ�>�Tr��	Z�k��(#�>����8�y��k.O�w� Ҭ��W0��p0|	�L�-�&r���.䌑G]�~��98�q�\E���3���-��#p���8� ��ĀF7�Z0������b���nּ0��0 ��^`��>�]w/Ѕ������S���e�e�m�8�?)�ּ�	,�<,1i�_c՞�+G�P>b."�d����u�+���8+n&.���I���� f�o���������ߗӍj�.��\FJr�m�D}�l��J�gk5�W8 � �t��>�9�_O@dn�,�F=]7���q����or��,�s!3
�u!�_�����9�N.�N���q��{kh�(jjiQr�EPMS$r.bc�-�a.�LBeՕ�<�Ƙ�1�b�9�c��a��T�^Yg���6Ƶ�n��: p�q&�e�R�Y�e�o�1S[g�S����n��V��Ixk��[T���p�hL�ԛE��c� g�`�Y֪�Q�m����5v���5�I��D�7[�s:�幩O\�ⅴp�ku�9W�˹`�
Uǫ��_��~W����נ�>���WhO��y$�R����>)]�k@=*�?3 �Wc9�$�;$���6w��`��+�t�97��*,�L�@v�5�r}�e�Yi'�4��5�K�v,�ց�9 �xj?����V����Sf�y�c߄����mX'�DV��q�`J�)Hr�}R��m��CZc���]�@3~�M�̩�g3dgv0�	l��W�N�N��wn`J�R0p�6Pg~�&�Tf�%���m5��H�1����&�ҠTxVA�O:�$ѷ�Nh{'��8lP�g���څ    ���M�0�{ ��\#�G�Fso54=���5��jT+�?C�:��{�����;ؑ w���6��#=�88Up���������"���m=*	�^�5�Ϊo�:��?+q����~^\r=@ʇO�l/oR�~x3A�quR�1i�,C�����Jv4����s���q��"����CFه3N:�u���v���i:���ɣ������aO������@J��ө�7��&G�"D��֐�j˪����㟜�R��I�bb�?O7ː���-<8wi��u2N�������Kڥ/�Y7�f0��6�����M
A����g{Ib�FY2�m��鄌�ņ�][DRvT�_i�r�o���J�05���ӑ���Oh��Ǐ]�����q=<����G���&������j��d��l����y����1}�ԗR�ik����H{8�M�e�;�B��
SZGpL�0��t��Z�֛C��6!~^���~j��
���l�tK��G�$���E�PW�Gå���KiuAr
a.��y��y��.�,��b�@�?�����
W�B|
����Z��ʁ����c�Y1��,�}p9`��Y-y���X5T-+��d)Ğ���ݞ�Xdp��9����[��]�7��/��$IOl�:�6��p�{���_
��sF��x�XL��J'3�15. J!�s������+�M���'�2�S���|:�յ�J1�6�r�ؖ�DY9��!�8N+d�1.��vp�P+����9��� �F��u��u�넸��O g���1}����t��/A����..�˧�XS�A���g� ��qJM|O�c@�j�`@�Ŭa�����p����������o���9%��_�[(�7�!�N2������{=��\.C\*�1��>}C*|]X�
(N��a0���+b�`���7N�8n�!!X�`��,�;s��l�&$xAZ�ErGّG�%<#����o��2?�̀/���`�1�U$����;d�17�������z~�\_ކ�d����m���μ̖%$��u�F��`o�4���{�K.���j�9xF5UT[��5U1����C���r/3�T���<!��I�� m�	(��YGP���&vB�{�]V`�=��ľgp�[�]��܃���5��s@`������G��kɿ�ǽ�s�X�mo����x�^/�<�bl�\q(w	ߋ���M������K���S��Ip^D3��րM�￬��>��zL�.F���ix=���F9:�7"�� [L�oN�n��FeNW[�����&�;n��:<d��#�'�*��	�E��q��]��ƿ`�N�ӥ��.xu%"��yk}_��,��]3T.]�z��)�+TG_[�Y��dC_H�����v�&�|��{�
bM�0x��K��L��c��$H{��,�	�%�t�����Rb�d��KO������XE܂׹"z�uM^u�!B.*G �@��[go���O��zz=��6�����вm����%�	{.Ap����HC)�`�v%�a	|K:�v	�F	Y�ÑoI}���˙��S8�-��a�hI��Z����c�ƃZ���A7�~�wLT.����֧,���&�]_����ޒZK���M�5���FI���%��߫DVr��/��L'�^���r]���&?�0��:��A��U�2v�wF�^[v22�T!���'PZ!X��d/C��p�.�(��K�$��_[ӓ����r�9ν�޽�EN�|U�D�d��Z�B�`�na�K�M�.��!Td������G8����#c�~C1�M���9�P2�1Erٻ�}J���A|�QJ�M.�b�L(ǒ>D���a�ԍ����~��?��}���U�nK
���(� �D�oh����Edם4-|�$��@���Pû�;�h���
�O���,<�ߒ�����V���;�j-KP@e3�%e��]]�|�xN88�-i;�{?�D𗮐��1��3oIݭsu����F4\���[�2b�:�np����ٿ=~І��d'���2��S����'UE䒓ޟ]�3B�(�K�xڂ� a�âA���CE�ڙ9Z2�a𒁾]A��)AӋ��kfv�)�S�6��m��[ жy)��
�'R1��6y��G����q�Pޥz0a�-��s�w^n�y�C7���(�ړy����A������wS�{��1���{�"��;<�d�� ���a'�Ed� � u�6�0�i�2��T��&@\�pl�p�8�4vXJ�Ya¥k�k�'�(�$>�kgϯ��jm�n���]�@����G�s�R'�v0���xܿ�������9��jIg.-�nH�����CK�* a�����ߗ�U4��1n�w���6�*���P�	(��bjF�G]t�e�`y��7��S���fA��8?�2-���v�
�2� e��`f�ibFo#a�&h��ZŢ��]��"������pщ�g��	0&CR�vk�#���8�_�\V�j���a�G���3����]K#]:^J����VM�nr���<I\���~MJ�� 3w��N���T�,���A͚
sٷ�Y Y:�����ܕ�2�.����x�KK�n���Z�DS����Հþ��}ݩl�^�}Z��*����.�����2��h����"�I:vzxi6���+S�.�ö� �|�x�?�)����T>�j��Y~�~�*�
꤂�x�HS�W+�'��Hjߑ��mh�ߑ��q��t������3��cW�lσJ�r�;��{�}�=֒��W�$]�v�n�upqQ~m������EB��*I�*
M��}��?��u>��̖����9�(c�ii�tVr{xg���������]�J!�ς�$G�l���ڗܑ�:%��Q@6�I�}�q8�צ�� �(�L���ya)�p�0��S��l�
�ʺ�=S��y,�Z��"Z�.pD9�>+�̜.I9�e��;�$�UI`yq9t�5:/��R �Ijw� �n'�Z1U���Z	d����FD݆b�]*a^+�A�6�����4�s^�!�,�̓9�wݲ��>h���U�2Sx	��@�=Y�bH�fj�9��!������fC3lpb9�V�@�ٮ҉$8��ל�����\��(��r^s�� ޠs��"6��r~^-`��V��ј����Z��Y/�*��AD�t�W�&���'���Ix#⍗ayl��>��iz�vkr	
�Y�%l�$T�ߘ�LBYG1]�vc�Q���Z���#�M����W�����4����+���V�M�}�a�zڇ.�p�o���*`��zS���	������e����w�_���͉�Ȋ@7*�Y��`����`��}�.lX*ER�P��J�+�w��͔4�U����h<��2�U
�R�g��a��mR[��� G�WY���ID|z��M����1�c� ˗ � J�����S��R��h�0�za�^�_�I�s#�M �
R@�o�jR��P(��9���Vfk��������*O�T3����b��Ͳ�Qbp���+�����M��i�+����
tcXY��P���rd�
O�ͧ�2�Df�!���t�����~96d8fev7�bF��'b��f�3K��(���TN��^8�GJ�1����"D#��+x�mHn _���|!��o`o�,[9p��q����-�Î�H;�����9z�u�,�цd�V�rh�x���p����c���	2~����ɣi�	4rR3(GKa@�olG0G���
>łsя��Fw:KOY�p:�h�����̧���z�:E`��a��������y��>mP-�l�i�[�t�wG1�#��
Nps
 ��85 �� ��Y�yJ3��H�ϭ�\?�cX��� �,NAT���8��n�
�g��H�n���vˤ z���(��nq�p��p��g`	���s �2+`}L,���ˌ� ����l��6" (�=Rn��,�~��p�S9B�{�I�.[�ɻL��jF��
�lǄI�Ў@����4�+    r�B�'��9�����I谤��%e��pp��3�v�����~�k������(��t��༙����ص�K��E;�~&���g����o)`�2����,:o��R�����#��.�U�jd��"8��Yn�2���0	�d��rNjT70�Ș22����BL��/7�`�L��Aj���0`�q�u"_R0�<�� P[�<G0�7~zyz��(B��z2%}c̴��cYu��}\0�k85�sAI�3��Sϸ�kQE� U'/�i`@�����m¹�=��i ��$PN�$��5�8
^X��+)]�d3���Ʌ��Ch��;&�`}��]X��J �e�	SI���9r�j�p�:h`C�Ly2�����v֐�c��:��,Rpv�mԀ��\ �pX����+YUY�w�\��ݶ���@09GpF#���	X�P�	8{��jddl$�J8׷.����j��� �0��\��H�p+��F�iR��o��paJ�U���ѦZA7�P޾���rO����}G��%?���}}2@�	�<���|ly��K����G�k����I+� �NE�>��!�|
5����g�]��d�J^'��{��3Xe�^x��b"o4~ܯ/Gi#h��O��F8�D�^)�#�,_ԳN2� ��5��q��̗>�>������:U��A�����",�Z�H�t/a�jH�y�U+��<[�@F�EݝY�0eE�z��7���c��y�p��Z��!��&^�,�����{��bwl��>���Z��kL��S~�y�><��{�#`�`��M���I�c�O���EUC0�.=���X����Ɔ�����φ4*#}ʶ��1�W�?j`�~�}�#L����{Y]bmp#��enA��G��#I�u8p"����Nm=y���!���I�5�Q�[� K�G|/VV��L�#����Y	`PXn�����;O�J�R0h��`��V �5Ü%�Y���#!kC���vĮ3��@�ٍ���g(�i^Q0��6��W��/�%�V`�h�Mr��ɠ�G����=?s���n��a�8��_skգy}��=���"I@�휯ra+Psӱ���x8];��<ܟDp`ɍ�Gذ7k��{ԁ;LVX�.������%s������u,b5�3��~�cJ��
>ر�<U&�K���X�
��X[�.˸���.a�g��ͣ~��:B����l�Z��rmE���ʬ�ٟ�X�20z����p���/�����`c�����%8�k��̮��(x`+�_��UF�m`��D��gl	t�#=Xń�Mc|�:�T�RP��
䓖/��G�-��țL�Ǆ6�|���T�-����<�̶�/���O;VM�H�E�j&tl���m�� @� ��pD"<l����G~//��,'CK�/�rw?��bur���I�F��ߞ���6��}�j� 5��'�%�0�6cT�lڳ�z&�c������ȿ/��{y_%��W�1���5a��M}����Ɂna�l�|���{q����N� �K���us�����-�in�~ɒ��v������oR
�fqfq���v��V!e��l�\��jN��o{�8�
K@I*�o;�o�b��G�.�BE�;���|-=]An��*���̇w�W��+�j�jBw3�T3('���Tިah\b���w��WC���,�TS��	:gh���V�x>4/j	B�8�ۗGzpt!u�2��k{jvm����Z���Ԩ�RS���te�;���r�^�0��r����!��Hu�x�=���#�!;s�߉�JTE�Tu#ՁF��8�����UnVȴ�<�i��K�N!Q��O�躆�g��1����_�}ڏ$�mH��E��&?�@�
c�P�8��A��a�c��6m��	��%�B��7�l��$� ���zzh�{�;pO�'����ħsq�<�p���<�5.��r�d���He��^w�m�3[�=]�0C��%��`�,�0�'�zg����O"v9N$�,l ���JE�-��E�'�H��v��q�S����<�.�0C�I��c�@RC���Ӕ���������P�cEB"��$����H�h���,�z�c��}+�S7���~j v[;dU���C��;4K�^@r>��?���5*�%6��;��yX�xɖ��pQ�ڼ]x�����%�P;��5ث�3L���I1��m,��吮#O�W�h��NWAIQ�ik|8sf��Y�!�e�Z8 p�N�Red��땊;e�"���/��~&0����q�1 �O9^4����`:lR��<5H�sdlf�l�����_���4D�9M��%Q�"���#F t�����w�8ȚK����O��F-���G�=�"�Hw�ص�C�sel��I�!�L�x��w���R�N}�
,i��yz�S�ޖ�)c����Khd�;d�2����L0�a0%k-*�&�|	S�|Z�F�<6�ځ?x
�|.��]��Z��ܰ�n�>&�\�?t���'>EB��w�{��	%ێ�SX:x�o�e�tE�'w���cH��)׭�H�j�]L4��9��:O���@���/��%�GIu`��4�B��k�1����#@Ԙi��jՐ��C �>�?�aBkR�Ly�^��)=���#c�R1Yx����>/N���jؿ��-�'��q��zi#�������1�����I��z@��zQJ�^N�Z����TEzG��&�YC�I�ns�$8�C
J?=��^����X��JW�����4U}v��1����<�`�y�e����8�����}��Q��M�Y@�))��]۶,99�
�.}>�Ͻo������_H%��O����à�ϗ;�殱O�~��nN!<0jʹl�2]�F-��t9���t��$c�P!�vʔ��v"�ӂ^N�?�3�
����p�{;���Χ�L�V���O	>��l#w� E���2�3�
n�$�=K��C�U]"�ຝ�=��l�4��W2�~�f-��na b��k,Zx����W���T��,� ��ш�����g�w�7�C_�����0�h�n���\�=K+��oh^r>h�QKP7@_���
G�*�"��$�r��ދ �� �/�w����rK�ŴO(���%�;Fa��rjh���R��#5��y}=|y������ÃP�&d�{��|	?�7l�ő�<��B��
�ˤ&g���ђo�L,~�{��8i��k�k�"� ��A3c0���/��F4�f܈�2j�j�(�j������U�|
�N�@tܴ$ZT��zx�wAa>.����b��E� �ff^-"="���I=��H ���0R�6D6P��Rs���;ŗ��Zt����ÜF�O�1�)%����n=�~'h��f�I�Z�y����m U�RyOOcR�Yi<���<'��|(���X5F�����< ]M��;<��2���tz��w��&��͢�E8rME*��tm��TB8d��
R�I��sA���kn�Ԩz(ȡ���Mp���q�۟O8W�j=S�����������ʘviw�lp��}+îSK1�΍}�ɍT�r��v^Cu���~s�VL��������e�~�����i�yH:�5�f���s�#s2�������ġ*��--$=cq�l� I끨s�6hp���Q��4��ny˦	���kj���T�-m�����A�&���vx@m_e�<]�u�Cx�y��0�k���j`�8���=�O��z폐`Zd�����G�3*����5o~�Oo%�l����/�I������z@cU�)/	�môU�'esKd|�(	c� FC�ݮ����q5`�d��Đ�
h�.��&�PM�,ó_?�	�L��EW���=WfLӀQ�U��i�f��u
R��n�f�����Έ��?7L���[:&n����ܿ0�	�4��������nB9������v��
�L���4����B���    ����5���:v@��7YB�*�p 8��Ao7l5AŬNyBЈ|)S��SDP A�WP-C�:O^�b����<��] �x8u�[��f/lcC�`� ?��q�ܴsW�0���lD�;�G�#0`�
�O|W0��`	�&�<.���O���_N��9�1�}F��=|��������K�>��#`u�Fc��������N�_>	�mK�9C%q��$T#�z�.lZ���� ���OĬ'k޾�pSR�}y�柦��O9�eM�ۡ��ĸ����ر�"������޸��x����%��������hP%�}����W,����]X��#2$N#��q�k�!%Q�b2�Z �����[ ^���4�Zсk�,&v!��(2���򬲊�b��q^>��F�o�R8�_��³U���TkS���.xxyo7��~-�-���(Q�L���]1⽻�+ȩ0n�7JY�VJ��$0{��I�;(�Z�v(����2p�ϫ���d���oX�b�i�eZ>[�GD\b.��~i�PO[���$/(�j�,"��k��[E!��0Ik�͟@�:������nM���K]��f5���Ș��[ۻ�`gSNW-�ew��xL�{#� ���R*����@�Q���x�;�Y�#�6�R޼������P�!�[��%��<`�x�הy��	��T���8�t��8����5	P1)�<�W��� ��̤L5�B���k�Sr�l��^�ԧB��Dt>�^.D#-����I
�/6�,���g��
��*o)a_�Y�RR�E���5cT^2�d�Ox���`9l����T+��VB�`�2�HU��5׸T��	����~�����f�7�l�J�U�C��av�n�
�(���ӗ|��.�`�!����t��c�Y/<���)�
�����1��#7������ H�� �||��+ݹ��N0���u_J�|�쳀�NP_���-xH"{��SSoA��+��W�O�ӛ"������TǺ���I��R��R���<h1��ؽ���Vv.�a�D��DV��!�o{\�V�y$Ja2��/�n�RXӃ.�,~��4��I�������yv-��cuÞ����!�cz?u�`�κ�d�O��^�ӒZ9�gN�2�;7}^F�bJ	"hᇞ]�QB���3�
��0���2���:R���CC����2��r���̊��� n��o�r8!���G?&�5��� �7>&P#������8|T��Ep\Z��m�t^�pmϾ�d���Yζʆc�JhXI[�u��˞}CBu�qk�
��+���+OM!Ͱ�&�U����~��.Ixݔ���d4�Jo���5s�㿕V��rֻV�Mr��!���g��L��ܢ�޶0k��<ˍ����_�<���Yk�WQS�`�^�'w��1'�����y�
��<��bֺ�����eBE����.\i�dd�ҫ=�F�K�/�V�g}@W��N�W���*���~�yZ�����|�)�
�Q�"ne���=�g��n�'�s����p���d�0,>.�J(BD]��?w�"(�_ug�S*v�ZĺT(J�L�]����<��d�%��J�A�0�ѧ���p2��"��JG�ɰtE �sy���o���v.Z���,x���o�j��u�:�Y�ԭ��(J"�N�t�ƉS�3==���s|8 H�������Q��?������8��o!����_uy>��p�~��u����oW�e�
� &ξ�
蓠�;� *.+*��>V��e�D+ac_����濜�piih�G�_S���3,�%"����k5��J�-YB_�mr��A��V������Y�E�Z6����&R���Ӑ����0r��uA�P���D��-�����m,���Fߎ�8�:e`^XVx1���*��R�(9���q�!	qK���]&A�%�z"z�+Te�U�*��CB*~<��}|Gٮ�f�"+JE�^'�fC���_��"l���8}H�ߐ�6%j���� cEENJ�A�X�h�3�>�;@y�6\�?���6�����j,1t�'��`���������&I8����|�>��7𒶠`��w5���/�m���" a箈����pF���|�q-���̱��<D�mQÆ(�z��	�*F���u{�Ƙ
A$̐PQ��f��Gp��e[H׌h�	k!ݎI+�A�&BFܐA�{^-�9�x��a�%�{��st�"�ZF�O��t�X	��%����JCUAb	CE��+-�!d)~�$�|gy%1mm'�·.�/a�6%;�����ET	�重�Lz��7jl�D=�	C��Y�����tY�`ʾ	:S����p��3u��@㡢q�0�o���]���j.ۦKpl�Q� ��aS�W^-���	������������Ǝ�x��j#=��#"�_�AK��v�TL'{"A�M]�z]��������7Jy�qE�B(����2C$s_����#"\�Ȱ��<�j��.n����U�#J8Na+�g�Z����0V$�,��7'b�!>F�F_w��/1�Pǈ������c�?>Ꝩ*�\����9&�1ɹ��zR$��
��~N�g�y�i.!&4b>�c>SR~���;��;�s{�J~�K�;�=��a���Րr+���	�a��8�����5F2�I�'}pЄC6]x�xS�m��5��5�ר�x�v��%��sh�/�%�D�& Bs~>\n�U:R4��)M(�M��GA�^ "S@��͗�����0�N�D�����Ձu	���X��W]�DF�#I�k�d���.�Nø�g�"�y��wNp����,5���*����~���^�PO�,qu>c�|D�e2*DJd�oK�E��M(ōvhg:�����uxa�����4Qt�d'w��!��e�����	Ht[��uƟ�^���PK8������K,��h������^����G��H��tU�b��8	�;:L�ޏ��F{:
DBp$��Ժ`�Ѿ�װ�;���Q�Q�+H$Y��A�fR&�<�k+1�z�N!��G�DĨ��u$kv$�B�!$,B�n����L�Q�����ѣ�P*�@e�{�n�S��E�Iޠa|\�����,��7']80Q���q�E���p�"��Bl�����zd��B����XT���*ADh��*��
��Mp~A��m��WxT�{���7B0 � ��霩���דdA,#���؀]���1B�ɂe����z���<��A�����Pkd�p�f���fw���u{�Й+�"��
}������V��N6�!�V/��F��#_:�@)��O�K�xD�A�_�tz��|��(}$��t�`Q��wE�$<�|��<��9�9�"8��nuI	!��)[u�O}�d65��	��*�T*R�>~)u�(�A ���>}�lˇ���B\Q���z�f&�F7\Q/��p�n `� �23\�"�g���^R�<I��G�`Cf�V�9
B8�����S�
s@�@�Th�<�s7���T���F���ށpA@�������};PMT�IO�����Oc-���]�bF�pi�X�ȋ��vx<�>��UAN}�����q�+?7�I�&������	0d��0�kk����Gx�/��\4���Y8R�K�:��%,|z٪�H6A�lT����྅�^���MX݄�e�<I����W��
Ь�*vv.X��N���s��+�pK�m�>�%��k����� ;�͏���?��ܺ�Jw�7�N"\�k�����KQ��P�{�#=��PU l�� n�k������~M��)��J	��Ѫ6fc��#^K��8]�IU�剦葒��Oy��dR�� �n����A=8��9i�i�����#�����
 �����d��	g�^�wt�h�
�4C�x����=r1l���2H8��c=\*P������qc�\aվ��2F�1�����׏Uܴ�    H3�t��,�ӑ�>|���}}.��2Q
r�ށ�~�O�^��qg�������t�����0VuL�;�_9��.?�/g��,�D91�/(8�#=z�B!|��5��b4�>Vv�ӳ�������N�HG���rn�/�)6V)Uр�7�Yt9_�z�gA�DM�.��8�L� {u`|��!?Я�-a�b��{ڲ~��:2�DQ`Xj:�,������k�b��&pX�s�~�7>�|ő��O[
PԳ#=�`����zb	B��c��j�h�\8�#6���_����h�e][f2�+&�4��mǶp&�d�V,*eV+��7�c�V|n5�������	Uѩ��T3aԧ�	>�pu�h~�v~�ޥ��B�1oץ5�̍SE�:��z�\��:E���ɭ�u�l;�b�C����Ӹ%������7N5��f[�ɇ�o��>�Z��e=���S��U�jg�D�`ƴ��| ��U$v���el��`'�T���Սt�1��v{9�p]Vv�K�q2�<�3:��!ұS��e���3A�Mt�T(Yʌs��8�S� ̵0p�N�
���� �й�'uUmila�Ꮝs}�5����=����s�Hu�������f�ܮܲq^V�����>�[;��q�S���F���M�;�e������3�I0�=�e�ï��{�AM�V@/l_mg.rp�6�]�G{�uVR�qϳH ���Jؾ�Vo,r9	�7I�F�Ь;����
�����瞂8d�?��;�9u�=� C��+Y��i��a����+aMB�ˤ�,
<]�o�j^r5.�v�a��v�l��K~�a�����O!rQ�`�k�Po�/�fA��ߢ��o@Vz�Z�0�I�%��L}��yH0�	�᛽���:08L�$4KZux��|��x��Aհt�}R5�-O$�ܩͣ&��Pctq��=����R���D>ha�1Z�aU�T�R3P�����v�WKd�$��l��`:�" ���p�D�t�`[�l��O���$<�>�0����)��~~9��9��r�ߕՒ��87I[V�l���}A�+̆��r�mư)gX'O�ەJ倵1n�I:{U���Dҭs�R�'�=b�a�'�6�r��!�#D�Ԙ4+<�Y>_MRPٯeL�+.�D$w���#ggX2�Z�r� �����/6d�Q�hzMP��/9ۢ\���Z1�����j�d2��||�s�o�ȹ��!��AR:�-���L��ƙы���t�W�;��2̕ �S�Gy��yy�xG�w��ҵ�2�A�����o	���m<��=4�cڷ����Ԯ�Iw)I<�����w	]�dm���}c�O݃QtN[�)��V�#��ރIC؂�5����f�q�4/��d�c���A�'��u�#���@5�Ҿd��BGS�M=�W�mKP�t�"@1WS,}��r��zQ�5�[�w���W�#諃^.��=}|�M�!�{�>���\>�Ղ̪�N��[,��O(�חy\�~��C����F���H�E�u�"ϚA�qgQ�4=���[Z�mcơBVYy����L�K����/���vu츘�ڞ��2���AŘ)����b��mnBN����6�A@0����ƂmW0�0
!Pp����\��[/Qܕ
>! �����|�98%���O1������r!��&�7����-���m"�E�&^H��^~�@j!wm��x�����H1?60��L���x�1�/�����S��%ɩ�0�/@ʱ�sBB��QF��s/�_�(���cO�d�u��'�P:�de]�3�F:�[F�D��X�����~/W��W����rK�s"s0%�e�	��R+�w�b����Z���t|�0-�/^bj�Ʈ���6��)q��f�GK�s��3L��渋z��i�P�K�;s#���iـ7.t��F��6�k��+ �rd��k懻\�A�fXI���s�z8�b��X�}h�]~|����ʀ��9�2�)gW� _�H�P�|��Qa|0¤�;��:AF��Cgg���<U�ݜ����\V����+Z�л��4�R���
���ϧ��y���V�i������vuǚ��K�t7s��B���n��\���ˮ���u��і��IL��E�3{YXV����� a�qM�mU;�؜�]��ے#`�����TQ�9��-��u��b����?A|W@ν󾽛�wܐ�ǿ��?���u[![�jH�*>�Q��	���Ǖ��$��R���ɘ�~�	@:%��R��ߓ��U��I^���|0xU�9fP���tB�������,fTz�й���-�CT��[�����3{G��U�|�J�s m�4Rg�p������Qi��	�����@Wk�;�;:2�����5�*��^ �܀W�\���xV�wai�UOW�Fw)n����P1M: |s����`�,T<���85OO~�(Ȳ d�CG i`RE�+!�z��*�D�"����.�׽E��1���㖀bY�����4 z�~�6(8��7 �T�5�_�h<.�s/M
���8���oI�U�?�L�Hq��؏��Pf#.:*��Hr�V�C�6�!Ċ�����%tR������-x�1�z���F.w>��UDY���i� u��^�\{A�v
� ����徂v�C��� 3���h_��Rv��AR���O�NW�:{����e���1������������#z:������MIc�-��^w��m�3�ÿ�X���S��p�}��=v�V38��J�ޑ�����ϼ�ep�����.:��2:*-��@����(g}��������''��}��u7�"���Cp@���+0�u����!!]:^�[�SC���W����Jk@A/:�P���P'���d$�N'�n�~�\8��QN�b���&f�(,)�N�'��$�5�g�����1��j�ǽ�~��mZ�Q�.���Uշ=[���܄�:&�Z�c��y������٦�uib!�Ƥѹ�|>�ͨ�w��.�a;�����̞�z<�'5
�8�F6h����]b ��'_'����VG[өl���P,qX-W+C����C��t	J�H�ܬ�i�X�ym�?�-���a\�z���sd�/��G�i�� �K0}�;�|��[�,/����X߯�p�9�^��q�?5�$�
�;��W����i4G�"��[�JT��-y�L:�w[׿ﭺ�5.t���e��z&c������1�� �l�x:�?~ ^��wq����!�ұyO?;}���4 ����{���>�Q�4������Ff���L�ǅ���m�|�J7gWA���T���,o�׃���ߏ�W͓��*�I֑N�<��Ig���F\?�&�_�?���;�l.S�~�pTj�9����?��v�� @�%�+�x��zLЯ�������Dyn���%��d�ំ�� L{R������ۖq՝���Ϗ#/��_����(3k����됬�����ox�h?M��1=�éɛ�0�|O���G遃�ɮ��5�g�N��$k����NS��.��C�>2%�(ɗ��ނ�΢7(b�2��o�nW9���ϡ)7v���.t�n:!�E��'�]�I�b��px�ϋ�L/Z\���8�)��	���[=/^�JU��!��=�����cΠ����@�ϗ�s�k�2�^�؋��Ǐ����V�Q�M���eS�����n��6���=�A;�t�U.�L*Ε��:ʻ�''=�z�ߛ�W.�?843�뚾$�����e�c�ǍKw���NjajEб�2V������;Z�w���#����-�{�6/�@ v���k%ƙ���w}���)T�����4ܼ��f�~>���4��묔+
Xǈ�f�./-���l�ږ�-~�A����`"Fސh�ƷG_����5ndf���L�;D�0&�	:{>O���t4F3���������h��]cu &u��`n��q�������������=i�Ʃ�m�����s: �  �JuM�����&"uOSێ��������!z/am]h=����fg�h~ބ��hX���iC��K���=�	��BJ��3�h�6ȢMTN!���?���A��zM��ݍd�D�R&�k�
�w��P욫��VƘ���������� �8��	G�)����N����Hp�Ss5���H&��g��X���L[T��#SHl_F�i'����g����}4_����n�r4c�>�����B�M'�-���ĐbI����u賄��?����D0�i�����$.
��5�ƀ,���(6��R4=�(��̇)BzPy1��4��2�dJ������Y~ǵ�ym_ӄ�����h�����ae�p�v^O��Ï��k
�r҅D��0�Y�7����ȃ��k�4���ԿG�p��p���( � ������wd;�$��eK���9���ʾj�Ӛ��ٔ������4�DI2��&��������D�|;�[%���L�H�$^	.?��v?��O;s�$?ݤb�;*6T���d�og��{|��>$g�8�zC���w��3\��ż�xΜ��i���&.{�ÅG��]�_�Mh2�5����!��sC�r����һ�"��E�.9�X^fg�Ύ�# q;ؼ׶n{/��V��Ir;wJ���|�C5ϙ4�9Wm�G�¤b�����v��*�a��u�6Y䞌�La>�g[fJue����!�r�䌾l��?��������a      �   �  x�M�[��8E��U���(��?�l�R �51�_�܃���<)��+���~|؃����y<�n
��՜�O�D�������\�y9��݈�D�M�'��-%���=`͓3�����1kD����7�#�Jr���Kpp��8	ޭay����������\ҞFNppkm~0=��|��)Z�D�\�戛Ȱf�N戚��ö<��#j����k��Û#~b�V�9"'2�u��7�ZV��1'��J`|��'�$��v#�1�%o�dN(��y�՜�s1'D�ߚ��e<�":���ٜ��B�ӓ���/2�6mQ�:!$��͜����9c$���y#$��s[}m挓���S��bΈ�j��k�Θ	?\��9�3j�m�9�%B��sFNt�)u��Z>�CeJXB��{�eJ�\�SX��I�gN��E�0�r�C͚P0���D悙ؗK��`&�媹 %��ҵ���R�ģtv.	i9i�#�?�W��[�"����&��P�b$�h��\1�A��ŪU�"%�/抎H\\*Y��9$sCG$楹hn؈�U�sCFdt
u��K��.�?�3�4�:��k$:)/���������!1�����T�NA���[��n�{��������GJ`��/�GK(Z�#]��[��J0����I��E�ԣ$Tv%=%��'��!��vMG���Q��#$T��6՛;Z�E�쎔@�.v:�掘h	��c︉��)@M�O��M���)掜�����B��`�*�[Z}J����U\\X�����T��g�q/���*�*��U���[�������n����7��#%5��=���~��.t: �����^5nr��B�Wm�	 �_*��	 �4��~|�К����T��@9�4`�i�2�`*��+DO��0�n���%��P~,]��]@��A1�۬��CP�mk?E��H��i6z��t���]��G� ���Ƨb�Y3�A� ��e�2�Ee�l*�s�ӊa�D���m��[���,�¼/#��<�ñ��V�W���2oH%��o�.H�VB��w�-M��;�+'��B�����F����x�t�/�8s�Xd��4��_*֭�K�9���y��a����哖����C��ۛ�������aRBkh���"����*��ڳ�_����.�(��Z�0s]4S0���߿�1��l�      �      x�3�p����� ��      �   Z  x�eSY��0��O1�$��2<(B@I".�r�sd�(ɏ�t�t��PJip�kX��q�Bַ��+����i�`��`���@��Ѳf����gR^_���w=.�ff��B�=���+LxG���*����`�184s���K΢r�E�=���� ��BjUT2/KyH���X�ݎ,�:Р_R��cgX�d#��]����v�����]#�@�Nߪ��'�
�U�G�lR:/��V7�zt۾�m����JѶ@G:�R�����d��Ɋ�) ����I���̥,ΨB��H	��Jf��_��d h�9����&��P�'h��Q;��Qz�4�*]'��`�W3^��<^y��6��-��O%�u!!�%��j��L��0ak���?!z��ҽbo��x
z��~�;���8������Rh1s�q\h/��EI����So�yQ@��VѺVu���vy����tr�[t�K*a�58|߽�3�za�1��略.ܨ�8�\�|ΰy����cﾀ��F6�<�K�M9>7���B���{ZJ�˺`X��3�R�3���S���ٸ�\�����~�I�z���F����ĉ�X]$by"A��].�?`%&R      �   �   x�U��B@  ���S88/6�p,ɬ��M�0��Wb��w��|���P�~���� �EE�9�x�مN�6,P����}{��󪳌��ǆ�˼F�:��;��B�6OTpY��������4/����ĉ� �Flp)g���sٗ��KUp��s��"���~��7�      �   9   x�3�tt����tL����,.)J,�/�2�v�H�KO/�KTp�L,N����� u��      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   $  x�e�Mr� F��)|��c	�ϒ6��'0�L7��9*�40/�y�>��@/��ٝz>�#���_K�V��p����O0�S�*���p�%�8(�d r����Q�ز�}�R�w�L���Lmy�7�qV0W��_6���B��$>�m�`�H�7	�ޭ�+�'���i���1P����F�K�!��^$^Ȉ�Nh����K���������:R?4�s�_#�0CSˢOG.���v�3�j��9�9D��ꆩM�$!���,���ƌ{�Fu����۳�a�c��I���yG�_I�x�      �     x�-�ɑ1C�̔�l����Hn_��M�N	ɵS|iIR��n)�-���?ِ#�r mɁ>�ڤ�M<�\��Rj!��[<�)W�K�h�������&�o��Cݐ�Y���%�^�G�t,#GF������Փ��R��0�uOñ�>ê� ����"���.�K��%'��a�����S#8�f�~����H?�[)V���N���/�F�Bqi���̌&F`�M󠙗|���n����}	K񆳾.��>�4�H�k=��Z�1x�����S�Q�`�      �   ,   x�3�4 #N##S]C]�3��Ǖ�,c��1����qqq �	�      �   �  x��W[n%;��^���e����u\��d<�D�A:%^U�\W����?�=MXƍ�j��Ec٩'���q��T�Y焥!��x��1��>!>oq�����1vv�X(hH�h=Q꩓E�ROK��6&�����1���,$���\+��7����sI}[��Ӎ�s4��;s�g\��V*�r��F�H�\���8�TsF�tvW�&^��TE����7gAu��.b�0f4��l��L..�$aN�Ȏ���v�74o�Π�S����J���Ka�f ,$5B�&<e� Cj�����P"G��Dr	����^%fb$��mN~{YY��	��
����R�6i�����
:wVg��-:�H���;�{ȥ#���l$
Bfx�� >��Q��.�q#Ŵ�r��U4�7� :�2����Z�>�'�p7�>�E�v��|P��o�JBgA���v�0�m�=9�[auTL�Υ�L��Sp0����l�>b' �E��Xk�6�����7�������sS�!���͛�4�k��8HC�{.��r�\~�Zn�2���O�]'w�Ws�1��Kc��H���6v]`u7���B�t�cVr:��Ơ
�T3�v�|�g>���d#t�� �Ԇ;CK�j:ul
V��O��0������/A�׊�`-ܸʕ�>J�>i4�a��k�b�ÚxG:�~j�I.KeW,����f�f�᐀Ռ)�2��	�}�g$�v� �T�:���h��Q/�2PG���[�^�("'�s2����\�eԾ���{`8!��
V�����#dP�{R^^V����ӏ�ϐ��l�ܮg!��R{��2|:V�z��=fp����Q}y�������=�s$�9���]���a9)���_�5`/�0���+�՝�Zq�u��|�N�q�C1�u�b�!�o��L���k��h,����3֯N����ߟ���^%5�     