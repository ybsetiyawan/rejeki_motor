PGDMP                      }         
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
    public          postgres    false    217   ب       }          0    17133    m_item 
   TABLE DATA           c   COPY public.m_item (id, kode, nama, id_satuan, id_jenis_item, stok, hpp, aktif, modal) FROM stdin;
    public          postgres    false    219   =�       �          0    17142    m_jenis_item 
   TABLE DATA           6   COPY public.m_jenis_item (id, kode, nama) FROM stdin;
    public          postgres    false    222   A      �          0    17147    m_satuan 
   TABLE DATA           ,   COPY public.m_satuan (id, nama) FROM stdin;
    public          postgres    false    224   F      �          0    17151 
   m_supplier 
   TABLE DATA           J   COPY public.m_supplier (id, kode, nama, no_hp, alamat, email) FROM stdin;
    public          postgres    false    225   9F      �          0    17158    m_user 
   TABLE DATA           J   COPY public.m_user (id, pegawai, username, password, id_role) FROM stdin;
    public          postgres    false    228   �I      �          0    17166    role 
   TABLE DATA           .   COPY public.role (id, kode, nama) FROM stdin;
    public          postgres    false    232   :J      �          0    17172    t_retur_receipt 
   TABLE DATA           Y   COPY public.t_retur_receipt (id, no_retur, tanggal, id_supplier, keterangan) FROM stdin;
    public          postgres    false    234   �J      �          0    17179    t_retur_receipt_detail 
   TABLE DATA           T   COPY public.t_retur_receipt_detail (id, id_retur_receipt, id_item, qty) FROM stdin;
    public          postgres    false    235   K      �          0    17184    t_retur_sales 
   TABLE DATA           W   COPY public.t_retur_sales (id, no_retur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    238   dK      �          0    17190    t_retur_sales_detail 
   TABLE DATA           P   COPY public.t_retur_sales_detail (id, id_retur_sales, id_item, qty) FROM stdin;
    public          postgres    false    239   �K      �          0    17195    t_trans_receipt 
   TABLE DATA           [   COPY public.t_trans_receipt (id, no_receipt, tanggal, keterangan, id_supplier) FROM stdin;
    public          postgres    false    242   �K      �          0    17200    t_trans_receipt_detail 
   TABLE DATA           N   COPY public.t_trans_receipt_detail (id, id_receipt, id_item, qty) FROM stdin;
    public          postgres    false    243   .Q      �          0    17205    t_transaksi 
   TABLE DATA           V   COPY public.t_transaksi (id, no_faktur, tanggal, id_customer, keterangan) FROM stdin;
    public          postgres    false    246   Z      �          0    17210    t_transaksi_detail 
   TABLE DATA           c   COPY public.t_transaksi_detail (id, no_faktur, id_barang, qty, harga, subtotal, modal) FROM stdin;
    public          postgres    false    247   p\      �           0    0    faktur_sequence    SEQUENCE SET     >   SELECT pg_catalog.setval('public.faktur_sequence', 97, true);
          public          postgres    false    215            �           0    0    kode_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.kode_sequence', 2, true);
          public          postgres    false    216            �           0    0    m_customer_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.m_customer_id_seq', 2, true);
          public          postgres    false    218            �           0    0    m_item_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.m_item_id_seq', 4345, true);
          public          postgres    false    220            �           0    0    m_jenis_item_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.m_jenis_item_id_seq', 161, true);
          public          postgres    false    221            �           0    0    m_satuan_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.m_satuan_id_seq', 2, true);
          public          postgres    false    223            �           0    0    m_supplier_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.m_supplier_id_seq', 24, true);
          public          postgres    false    226            �           0    0    m_supplier_kode_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.m_supplier_kode_seq', 24, true);
          public          postgres    false    227            �           0    0    receipt_sequence    SEQUENCE SET     @   SELECT pg_catalog.setval('public.receipt_sequence', 159, true);
          public          postgres    false    229            �           0    0    retur_receipt_sequence    SEQUENCE SET     D   SELECT pg_catalog.setval('public.retur_receipt_sequence', 6, true);
          public          postgres    false    230            �           0    0    retur_sales_sequence    SEQUENCE SET     B   SELECT pg_catalog.setval('public.retur_sales_sequence', 1, true);
          public          postgres    false    231            �           0    0    role_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('public.role_id_seq', 3, true);
          public          postgres    false    233            �           0    0    t_retur_receipt_detail_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.t_retur_receipt_detail_id_seq', 9, true);
          public          postgres    false    236            �           0    0    t_retur_receipt_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.t_retur_receipt_id_seq', 6, true);
          public          postgres    false    237            �           0    0    t_retur_sales_detail_id_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.t_retur_sales_detail_id_seq', 1, true);
          public          postgres    false    240            �           0    0    t_retur_sales_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.t_retur_sales_id_seq', 1, true);
          public          postgres    false    241            �           0    0    t_trans_receipt_detail_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.t_trans_receipt_detail_id_seq', 412, true);
          public          postgres    false    244            �           0    0    t_trans_receipt_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.t_trans_receipt_id_seq', 159, true);
          public          postgres    false    245            �           0    0    t_transaksi_detail_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.t_transaksi_detail_id_seq', 3763, true);
          public          postgres    false    248            �           0    0    t_transaksi_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.t_transaksi_id_seq', 95, true);
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
       public          postgres    false    3270    232    228            {   U   x�3�4000�r�r��T���⌀ N/GG?o� G?w_W?/ ���+��Z�����i`ahdlbhhjjj����� ���      }      x����r#9�.|]�)tY�;yJ2�l�l�e�!�]����?~|H�̔�gb����#� �A�N�}1�}�?w������K�6_���__��/fqs\������/����e�p|ݿ�w���;������a���BPO���&@iK�\^v׏��~�sgl���/�����'��%Ф2k���x��_w@�\�Ϙe�_|��Ǔ�������������/�����s���i�v9���Sx�H?���?ގ��߼���:�_��zg'cF��B�e�x=�X��4O�Sϫ��Δ�]�Ώ�ÐB�8�l�e�з�{]C{��|�%{@f��0�}�����������������q�~x}�?���_����������0��p�O���y��;��A%b�K#�u�t~} N��� E�s�z��'Z��e�;}�џ3z-��������k&Eb�������I>�ԝ���QޭA�{Z�а@���������y��+�5S_����u~�u�����mJк}�`o�������_���H?O�/��� ����O
�tH��S>s�r&��N�g,���dpXV�@�5�*��xT��/�f�1f���(�5�����+ϧ(.�H`���;x�ð� ��<�������)�qa����"�	kD� �Y�����~|<\
f��kh~8�����p�H�̿^���4���w�/��^���_,ѢU���Bs�n@T���B|���z��M��i=�r=�Q��?ۢ'�o!���0���<�_w�y������Xs&7}���,���t=�@@P���%c�t ��S�A-��v�k����H�0_Y��s�P��P;ى�f�����w�a�@f"vD��������.6�- �M��}�������NU$%�9&�H�cl��.���<^�d��i�F2�Z`1!����J�BbC\6������M�9)>���?��΍u+|3�C^�F�D��*9�; Jil0m]3����~H(����6Jy�c�I��X�Vv��NG�?��4r)^+cHDҬ�B�Z�UU5�E� �נ6�������!�Hi�|刺�\��<�g鏋Q8�e���֟U6[���|�X�bJ ֑�U�gs�Md����ĶE�-�ZSq.TtI�������$�,�ww�\��wR��UG_���-Em���Շ�Г��)`CO��L� Qk6��Av�,P�}U`wm����}�J|ޅu8yB�L��c�7��4�Lc������խ0��"�f��.}���I�W���l���HK�E���o�����<�����m�z B���`�4�*�U��B��_�G��>>.;��Ǿ1��yc�&-����ǩ��%�D�%���R$����O/;Z�?i�����y6�k!JL��X��,1v�F���كI%�@I�b`HWK4?)����vf�Uli?�Ū�ԋ��\��k?ސf[Y�A{[�b3�$� MD�c�״էH���9���p~�:����M�~l����i�"�X�)�lO[���6��P���Ѥ�l���
~y�?����.�ؑ�n�=�@+��u�)x��O�lEv��X��e�v�A�\>z�T"ME���i�7^=�cڧ-���8^��Xh�a��@��x������w�ֿ�����O:����Q�;/6c�&�쾾�ߏ�v����WY��X���F �J*c!Ҭ�~i��đ��B�����Jm�Oi�&{���?���ĝ���Չ�CxN��P�>�c����.��&�����W@�q�g�d�	!�j�B��q��P���������Z}��<�j���,�U���|ٿλ�_���"5o���������o+U*�ڲK���?a=����K��<W��sb�%�E�)���#��+�Øʕ�ìN�;��u�t� (+�萻m��^��g�L��� �El��_B&"T�Mw�W��Jj���A�o0LY̪/k$��� ���v�������_�Ԇ�mt
��$�d^�h�Uѩ�I�zj�������İF��H'N�`7@�ϯ�x�:���|d;���zW�Q�˟CN��C�9�C����I�ds�Zʚǖo�5!�M�>�^��
u��_~NĊf����nZ��Y��������xE�� ���xP ��4�e��V�MA��$u BѺ��%O9ރ�����'�X�',T@�{���Ka@��2�aWR����?�8�%M�$��n�wMohr�k�*e5L� �a���,2�lE��V�Ҟ����nA��L ��59���/����W�b�Oa�d���EiR2ٛ�>}2ou��hނ��}���q��eݮ�8	<�͵J��9�L6�3�3�lY�p����tk���)'����&�Y��F�E��"�s�-y�l�7"M���N��V}n/L6a`�T��n� b���٭��F�8��q{z�]���+���]�Դ��M�a�($�u��Bz��DM󬙿;���� -�i葘3[���'ֶ��ܤ8ɡ�k���|*(i��e�lU�d� O˖k��/�f��|�2�81V"r���׾n��I��)�ڜ��2*�KF҄yIp.I�ٹ�A���q,��- ���ϊ��Ab��M��}E�s���N�J�/͍w,�3j֪��8~ZKђ�Ȑke���S��nD�:�Y���� H���K�[=b��w&J9M��6Z��4U�L�E��V��YF�Ό"���'��E#�`P�'?��u�Q�e�d-N΃T}�<��T5��	�/(�֫<��}:����'rlY�:`9��On�Ho�Gәe�Ƞ���������I%�|Uq#Ȋ[���g_��RB��u%q1.����1��{T�`a�]��^���0��ϛ�u�*^�q����k�?(�O���3܌4�66Fξ�%�s	�!ȳ'�Vz'-���X7�g>�"+�f�g���tށb3Ӧ�d7��t2�[��8��)�6�t�w�}�I�?��2#Y�C6,/��X�%����1�Փ�[:W=��F��-Oºha����X�8x��q�6��"�:G��?P�'�ȆV#��:��妠1cX�YǑ�o7-�>M��pf� �l���,?��0�3w��d��/J1�Ջ�'���\-_�"{���Q����>�ܛ#Cf��$�o0c�jڙ8 :��Sx�(r��Q"���O��b�Y��HxRI�%�����J[�:�8W�@������z<�tn��,�!��]�/O�����k|p����ns	<���r�1�R�ÈHQ�䬿����OE�s�2@�KZx�ޟ��u��a�,��v���p|FK���<=�߳������'��%c����q����#�:�DAf����Z��6����US�3~Yqx������	_��|�?���%�3�s�;Q�9�q+h���`�ϰ��ww����p�۟�ezD�lY'������n&���@��$�.� ]�C��,���k�:������H{���zk��o��	9���H�������?�~?���٢A��]*��bh�#s9m>~:?��sjA�Q1�2I<��i�I��� ss7X;R���H.!X:���O;����`����8��	�,�C��/>K�y��;��R�!��3���Z�d�e�������������#��Y2�(��$+(���?^k5>�j~>�k�P<��ژ���.vV.o���B�3LO��(Ko�Q���R���%��4B�o����stȟ_�$�'�ο�'��/�{��m�����y�����`\+a�@�C4.�����D��CB����#k.����׺_���_��6��@1&��l��/j/��3�%���&���/�}?�n������ZE�}��~9�]��D��)�D{���G��������<(�!m��AY��tw���z���9�'�|"��`\��Q�t�S~@W���O|��_v^<ox��҅����f]�8���W1�U��b�@�Q�vI�B����c�D[����P��q-�9Ə�����?D    ��i]^�����Ќ���7��L���7��`�,���w�O�T���'��A뀲v�|Y�b��a�ܫ�Q�gE��jB��C�����T%UL)$�s���
���(�-Ǆ��o���*�ŭ���S�ⵤ83�d
ȉ�~������>럼�2�|(L��
ק)�Ҿȣ�=z��_�')r��Wm���6�#_pC�f����uF��!TL�χ#�[F��5nA%�!�]?��x��/���)���s��/?m��:d�S/��g�>�k�$�y����r@/N��g�]"��E��~)�����x�:�ں�z:��\�:WƩ
�4��>��aUHV8ru{˧�9XY�N%"!�!����A=S�Ѹl��V��(U��]+�x䐈����^�kg�\g� �!�'���*�9���Z	�CR��,&S��Η{����]m���\9i��,k6��j"E�_^��wo�?w�� ��)U���3vƗ����&���ٜ�l���sZ�/9|=�2 ��.���Ry�H4��7d��|[o�Z!
	O�wd���(�|������N��>�O�y�,�u��|���k(�3U�xa��`D��#{ Z6cWj�L����q�����M6-��r�$���'MH�[_�5�-�Ex��1~]jcK,�_eR>��;r���YK�o�ԑ���"3O����V��L�Ǧ�F2�ߗ�[+
�����<����3H�Õ���m+l�si�a.��˪���|31�0Zf��Py|W�<����lȋy?��ݿTª�w�5EL����bQrN$��-�!Zr���:2�>������p�0�\�'QC�����+<�x���Lx������,Zg����ֵ��x�-Q��N~�WP�J�疜�)��?0��P@���p��0�;+ ��N���:H�o%	�C���~V�����V`�<d+�xoF��4\��gE/8��7^~ȠB���~�'���(S̢�OX�`��<�i�����ڿ/�����r�HفWb�����?W!r�=F&Ň�IPB��NR?���Xտ��r~�%{'������~�cGn;�_Z�7�{�_m��.3���C?��3�����/\PGbIx�����=����/c��7�F%�H����9J\b�X���b
�j�y��G�(櫖L���RYGD�^�|�?��jmd�mSF!"��:lqq~���ܑ����rV������i^qR�N[�`�I�uC3:m�K^!Z�`�hF���r�	�6�ko0���?}5�^�����E��z�}t��K���-7?��Ǡ�z�)`Q��%��0=�bjQ�R����X��g�&������O�������Ht�����M(��ΪY���E��Nk�����Sz)��(Nv])���ka������g�)x�ĳ(�r�v;�����Fo�BH�P3��D�RT9�L2ᰴ�	J���Ss	X{!�H�sڮK�#Դ4��x��b���q2��b�_�T�e���J1���(mH���O��++����';����M¹iPv������Y+7�*�wl~/�w����Y��i�r�W�S~�r�kM�F�{���Z:�"�KsǕ>�K,�m;�r]J-"CW}����)G����y^�S&e�l��i������A�������Ge�3��0�u)��q��R�r���.[��e���H�zo{w�^J̀ZmR^;Q�VD�wRf�z�������KB1�M���rxgXj����lpr\��ϑ@����i�
�Gޑ~�>���)�e�����'ږ�'4�Kvm����N�kb��g�!�޵��TG^��9���]�����6(m���P��wN���(AV��&v4���k�5K�BNcUG�B챈�Z��t�e�n�8E>�w���6�p%�#轢DK�}��#�V,��^ЗBlS�`'����ص�6b���w
����2d����S����l�~�=:��1����e\_���<����V��tK�[���O_��ő���=��o�:�$�k�Ѳ'��4�4����Cl't#n���fm�"�b�"i��
�;��\}q�<R�i�� =���̩)8~�n�W-ap��Ŭ�̰�j5�^���{��Y�,9y��NG2�俑/��921"|KU���i'7<	9���ܕ�1E� 'f��i��.p $Iҧ%�$�!��@��U�ԇ��T�EJ�VQTu˙N�Lg12�P/[��W�Wt�kSX��5�)�����حAѴ,h5��u��8_P
�-)�9B��^>߮ӨpGEB[�|D��"����/����xQ�y�"����a� ,����CW�U�|Х\�S�Ta���Nf�}��~=_�KD)�����w�����(�
e+��W0�"K3�@jj��Q@�BM{��pa�"8eUgP�&g���
v���M%F
ʗ���\Q�������B�PTJ.uA�*�F2n�u3�31�3D&��z����s.���k,�\t]�kg"J��d���#k������ts�H(O(rDH����'���Ixs|eǑ���A����程G��kؾ@�u���{''�tx ��q`H�!��0Z!,+ą��|x8�1,��F�*P�6�~�;{�@�=��8Uk_�=�m�ĵ�}�4���B�HZ��J3v�3�GZ���9��h��һ��T3�|q�����d56��y	$�X ���Ƿ�����~G.�/��.c#{������_�����[� �`��F���T5�'`�7fj�o�>�{�׎��+yO���d ��c��m��ݓW�����>VސOWs�^r��,��g��瑗fߤF���3�<9���.в9���P�귰�?�XV=�%�h@�;���n���!U��M��I|�\�Up�I�̼�+4��X6�0Ђ5Y���^�O6u�F��侃�W���xqu��~#�;I"��h�6�NN4BX��z�cd�"��aZ!F޽�_%i�~��7��&���G�E�=$�6����C������O��ڱ%/m��>$��ߦnO���1����햶�qe��m�ܵ����WwR��-���>���Yn�x�EYJ��6�ń�����taK�:�e�:0 �R�����R�N��գ^B%��^�T�#F2(�i�
�>�����>���L|o�RUT�Āj�������M�p�4b��s�V���ڼcQ��mN�:���uaC!�	Ip��&��*򍾒�0|��
0(73.:�UE��$J�5n�.�E=���J��*�DNrh����kG�|�w/���jQ H7>|<|<���e��6�FBH܂_~>K���k�d�f_/;����(���T{�C�W���9���ј���%�c~�����
��t�EU+Փq��(�����׊A���ɨ���7��O����vh��G')-g>���q����$�ҴF�m�Op�����d�r��XN�X�J\D�!��ҌwH�Mn�����JC$H�o�]�f�&yH��:-a��� LL������X�M"��-tG�Aqm#-7���c�W�ղK����,�!�M�&$���=�}<��m/&E; �-����ϳ$	�����}�M���Ч�D�&,a����}ͧ&)�*fʧ�L,M&�׺��i��ʐ�Ϫ�P��G�U.�����$#K���37���$,d9��+��qdcȧ�$r��˷�	}�8�vo/o�4 [T/w��8"��Ȝ�r+�#�[�t��n6a��
G��w���kNT �I��q�_'�u*��x�#d?\�?��2��
�N}�D4cz\!����u�Wx���7�59��D�.�[�J�Y-Є-��g��}�1ȔDN3�P�;��Z�vS�6
�gR�4�qi�6�Mj��{�Hhͤ�F<m$��ɳ��7��ٚ����>>�G���rd'fk7�����3F�!��f;p���e@!�+�Xr}��{��=(��1�G�h�Gr�Ӛ" >؁׷����hs�y'P�6m@W    �℈�3;��{��`������7��M����M0�BU�]ّ���sk0G]���N��0�����i��v����I7p�ݦ�sw�L�t'K]-M���bi�=:�L,uq�l��A ���n�j�q�)v�)���v"ICo�ÿ�ih�Юs+�w�����9s�!���d�	M$=��/����B���ځ�0�<z��˪Ɂ�IՑ���� ���3���>m��=�-�u�&�����v��̅f�x�l?�j�w'B6���.���K���/���w��x����0�8x�i*�U|s�jSU~�oO�]΂��	������S$eOnİ&j��IE�Q�`t&q�U<�q�,B��Ji;���$��p���R����%�/?�?�˦U�L�2��e���E�H����L_�̦
�:��_�������Җ�
���8��b��wOew��s���ʧ�<�l3��a�O��m�/ⴓ�,����;��7��|迒}���_=�f^P�?�3���kih�W��#�]%�;��C⚁�w]6|:~6C1��ESR�<��ں���͸mi����q�ՠ��/�X�=N�CR�����vUˉ�J�E��j�b�y��*㲘�����ᶄ�8���A*�ȑ��Eڴ%�Zi��L۞4y��2�H8ȗz<�/��������9��;���U>��b���� 3�U=��Dg�R�uJs���HA�_�cYQ�i��b�`I���걥�����a���˄*�Y�<�}~�Ϥ* G��!���b�2�q��g��*�/'��)�ı�Q ?�?U����&��+�RǊ�}��kQ�z�w]����9
9�"�E� �!1���2�g(�e�Kʢ�a�
CČvS>8���(�|;��b���C_%h��6yF�0���G����zS��P��<�2ٔG j�Y� �C\d�A����;�vD�k�W}W�uML.� ��cjP��6�a�h+ĥ���:��:I]���`����{4J���=B3З�"?�jB�<�ЀrפR}[*��sR�$A<�g�S�;L�v���=��g������F7��X"MZF�� 9�Н�d���NtC΄�0��y1m�|u�s��֔��/Jϋ�D��WO�0�D~q��e������$�_�^~�װ�אsf�gR<h|���꽦�}�2�i.��_��ǲ)W�=���]Ѫv�0.^$�1���ί|g�/���E������H�d��֒�-4��_�@�I�C������o�)D̑��$��g&;��ĸ-l� ���V��5��P���m��Ot>y���B��ϣ{/7A�Qm\��Z8�$�t��gŶVB��%FDMG��<_��	��#)����5�ݚ D=��w}�?�����ϙ�cP��x� �#�8k��s�Ó>S6�.֬���ίqW7prؒA����7wt�D.E�;�\�Dْ$��c8ɂ�m�?��Q����~_����n#�
A~^t�꭯��������f�[Y���D]W��*�z�as��F���z�zO��g�3{�5B�Z�de�\j?o	�6�SN�L�uˈbw���q���hl����_vQ�4������")�m���ZmT>��N&.)��c��>�����g�[�.!�ґ����pa��K3�jԙ��!`�g߼l��B��bW��a��i���S#?9R,��{\vZ�䌢���7ں�g���I�ww�gΕ�u��;1�N@�]��5a]g�tCxQN���e�'��]�Q�)EV3���g��̒��Y!�\ܗ �<�ݢx5ڶ����۶���� ;X�fq�#G���a��|h
�4��3�L�vw�.	�p�
��޽��WN-��*M������f��5���_@����J��������2��7W�Z�LnZf��$�4���3y���<�����9WS�!�+��a<��N�D!��{��qJ��I��׏�h�7��fR6)mG!9?�@�&QI�;lg�zo%�y�~��դ��)�}w׵��Cn�n}���!^�D9��I\����L������A��_(�=�DH��f0��c7̬RnI�l�K	]�'���5Ѹ�ͪ�vy�_4/�h��G��S4�2h�(E����;�38��{�7_2rx��u�@�O�������vr�c�|"RƸ�GG�)�;��&�jkB=�5�6&do�����mCP e37�
QӉD�|������׃�K(�؟�t���L-J_�'��ى(O�hz;"��y��?�/Zݝ?~�e5�B�B.���{~Q]���w�o�-%��AU9���H�?	�f I��A�����t$F�&2�����7e�����$��q|����u�9�>��HFj��v����"���]��s�g�p:"��Z.��^-2�<����5��I�|��0|�#��#8���!n��?�:�	��i�3��+9�=x���#�@��.r�t`���0�D'� �׿l��{A�$;1n�[���Y��D���ұ���J�����
���cn{�.��ő�ɨ߳�{|��d��&��,��dW(�^ί��|�#t�e�`��ɭ�u�A�N�C����W���$��_wO�q�}~�?�h]N�J����hÖ��P�:R/1�V#���(��)u���������/��h����iQ 9��?�o��^�������y�X��B�&.�z���,�lId��X��5��ϟ��3�F� �s����y�ֵ�PDDQ�{r�s$g"���;2p�Og����#Z�i��F���:$�>���z��0OE��Իܟ�9�KJ@�TٜH:].�$����x��g���\b�-m�dJl&M�A9��6RR����µ��T-�lhggz\N�݀��C����o�v�/�����D�{t��A�@E$���m�o`D�q�l

�]�rT����d�Pn&�� ��_�c��y��L	�t�|�?���%�%����\��Ǒ�q�>-
GN�������#�d%3i(w=��O�7�%cHՆV1Tn��Q=�:����=�i#AqJ2N!������9��]�E`$#F�HU�>�?�O�	� IPL����#y1���s+�ʟ�j(J"c��<�rr�S	��M�o2Zb�+w�j���@ED�E���}c���$Y�����I�2����S���JE�QgS���v-h5ֽ0���瓬�7�&�����:�Hq&ȴ%ۛ���{y+��d���?�'�.i!nKV3\49<��]֨V���c�*�7�;m�(%��3+p�N1�.�0.9�B��Q����{R����wa�v�3Ɍ�2#y�4Y����wq&�qZhʉ�hB�~����[-�ɀZ��+y�ٽ��]2&1���<�+�-D�b�^%��`Zi.�ב����f�2�r� c�WN���;3o�v�fJ�>���r?\��<"?�;^ϧ}���N�۟r��{�Cc9$j����O���"V���͐)��L@rZ��WBZ�� ���%�����R�31�i˙�-ϓW'�2)T.�2��J��e����
��E�-#�O�n���9@ 	����o|! ���ƫ�I٠���������0h?J��|��'��>�}�F
�ϛ��#���P���M�E$��Q�i�.b�2�/����/l��S�
�x�$G���z[���Qf�I��(I��t	D�	R�:I�5+:��Oa���O.���#	��(�R$6޾߲�L�FIj���Kd)���j
�0�qJ$Na'u�ռ��[����	I�F��A&�������P"�X�"V8������Z&H��A;~�s	y��hHu����X�J���K�U�v�mN�X���hv��y�@���+������(�i�&{ٻw��u,73�?�Fm�vN!+#N�I!��	���`c!FϚ�,��&i������)gO	�5��g�?Vq��y��Q3W.��R����#�F�\��f�����@bl��}{Y�^��H@5��ȁ���5���f��+�k~�Y���dQ& �    ����O�o�����q`��߫���f�(l�~�z���V�fHɬ1�=.?'>&��y'�kq1�4�ĩ��A���@�dq�p�+�z`ιܲۢ*�XHi� ��!;�)#��R�p�U-�l��@�����*I&Ҳ�lz(��
D�M����Mnd"�ҋ��%�9�gKϳ�@��R�xb�ҳ�z��W��rd�ҳL�����4�ʪ�9���-x���ᙛ)!C��t��+�DAZzJڗ�ڠ�Uq0_VA�`��-ti��xN�"z>�Wy��妠���dא1��������YT�1/K�x��oE�Uh�:
g��&�Ҥ��-Sڀ�\	Έ\ٳ����#��������o�S��(�Zrj��_$-�w�k�JnJ�[)@����l��ō#�^�3��)lZr����0��}���5�/�:$� �� �����zor���Ϯ�cf��Ԓ�-� ��y��S�����%�p�!t��\��k����pXP{4��`8ڇ�Sɬ���^D���+�[��ш�붠�����a��Wf0�i��������6&r2�&/
�~�<��[�����ͭ��Ló�p[;�~~=���������~������dJe9��2rt�~���g�^5���,Œ�6z�i����Q��e�L�o�k��jZ)��[�!��7.�{����Z;��}dw�\}`��z�\��$A6��8k�P�[Q��[���g��]��1��U]��ƨ�(rTm�M�$�r�GV-$���"1�-~����qu��u7�������k���k+��ZP�e�Q���ݦ
��1mfU����)lZ��n�o>=�e���]�לy<u��(e�X^��_�Ә�̩_�����������Ϗ��
n�mML䠂|�%,Y�$��Cnm�a��#��ǒs�
��=�Ɣ�� ���`vx�����X�_�^u�d0I|N(pk~D_�#{�Xt�>hq�P�>���7T������n�Nt����I���h! �ct=��p%���S�Q������'�\�4���2��&�Qv�"��J�����~x���Nԝ%�3\r��A�j��_�e�|=h�%M#�[���q�k�0|�ax)l����tĺdW�I�����k�%��Ԓ(�X��5��~����ZY�ݐ1D�����:�YOF\H+.�=s�����e�'!+m��l��n5'�{˲�GY�Ѕ��eY��و}Ka�g�sJ4���re�fj�4�w#C;j�a��WA�Jr��-h9Z��S>kB�e�7a�9ㅎ0�%�`����8�08�K�
�J45ܮ���aY���F]�]-۱_y�9�]�c��-���|<�_��e��P�
�\���wI'�� ��'謺��� f�M@a�ĈS����.'���b�"}�̜�%��2�V�H�pr}~��f
�fJ��nLE{�m䋘ee�V&��t�� P��gM�~䟖�*E6�����F��F��;o��3�^pA���!Y�%�4�J��i�8�X\��������N+��>qq��?�(�(2�]�H�|.$����}�v �+*��9��~.U9��l���3�A\���-Ib�l['� �RZ�g�?����f)��vx��O.wx:����ٺ���܊w����S�Bl6��%*uPݭΌ*��}�������FB�"!r�K�i��샦���&�<��[eO�6��UpR������"]�\�ȥ[|����٘-��`6�d�=�]�ړ�|�<�E;�^�.h{���^�=�$�@��R��Ka���ѥ�{��?iiK�[���#����ҙ��r�ŕW���%{=hg7���=ܝJMj���O#��y��j(eV_5(���r�x}/WP�LV=v�q��%�M�W�7>�Q���xT9T�u��A�MT0=�7�r,Զg��8�]\D�߻n�5v.z8��j���ЌG�.���'�9u,�8�v
�2;d4��|�
诋]�����e�X
RU� �w����vn�ٓh�l��\t�i�xO�Jm�6p<��~c)
5�kٲJ�hbf6�c�W�i�+#T=L�r�,���J���.�tF`����F�Êp�y�ӧcՇ�ny6j�&k>Er�Si��󻔺�F^��fG�&�{��k���C�T���%�'����"L��ژ]��uJ���� �q��&a�p�N?��M'��V�M�t�첦�"��Ev���<�C|X��ao�&�5P?y@H��̫K�����r��-�M��v�� �#��4���A>hK�-�-������א�]a�5���+P���

�ݠ�`#DyٌE���ܸEb4�]��t�;�ȓ�n���o*t]?l�B����J��/=u=O��RzxNw���_[�\�s�}H��դ-I�
�q_l`��#�gK=,�����(�\��H-�e�Q%�m8>�r~�*M���@���i��?φV1S�	���ߝ�=H�|xQJ@r ����z�<T����ݩ��|T��0��Z]�kΠ|;<P������!.��o�A*�\Q��Bc�!��oSCҨ�~�M`iX
�&��+%��2�j�����n��fW��U�f�I�
:�Hi7�T��j� r�����6��pN�!Zg (>W��� B�ٰ�pfp�?_�幩ޛ���J��Qp)���vx�~��~�����7�����%��k8v�������rЗ�	7�����>�k���sl��"���.��锨����@{T\�R�H����5
��AC����K������2�7+��p�^�6�p�p�|jp;<p�)<5x�N�?��6
<C6��T�Y�����z8-��E!L�́��̛��ɏWU��U&�hl<�Y��|����m��t�܀��td\{�.8�	H��?�����	�Ȑ܊�����b�S���i��O���.A 48!���oA��T���~��ՓIs��QT��l�l�TD�k�-����C(B��bZ�Z�t]��g�pR0� ���Q~��	H��*/Q�*9�|�������Ł�8�8O�xQ��\\^���tm�I�q�_���\q��%�}�!�[DC�"?E/Z0�����'Ç./�O�~��D9.�x� C��8��!r�()����g��<�7�L�2�xA�+T�W_��=kW{��z�1�H���P���kx����k����NucF�Q��9� �s>�F}���~�l�#���ޟU�1��[QSH�$�2��F��5�,`��Ჶzzo�"iK[�pԁ��'r�>^��%��s��79�!�!*���Ǭ�]� ��MT�`�;R���T�5��F�\\���^��}�����֢A�Cb�Q�4�Xu����E1D(��t:7,�~?��)Bk�m���L�|�Φ1Š�u�j�0���d����Z�RR6�Fk�Q����ǖ�]��,7���Yo��j����<v�_���}�(���\�A"�zi"���P�r�V]��	���o���ȧ�ϳ���%w,��h�f�Ҙ����?fT͉ʇ!�l�Y�4�njQ8H�c�]�T��R�x�85����s�$C��HF��ܠ����yЍ&�s�2�f�j~�
Rc��g&�[cb��25W�rw���l�����4�Rc���[Yv?�('�d����?WF]�W������s>�޴Ǳ6�"����Z�����R1MՉ��,��^�V�0z�H��	S��+B���fV$�Xc�-��0ՙ��	=il�̖�kSZ~���d!
xi�5��[l^D��1Ȣ�Ս�<�"��۪#O|9�إH�~��w�%1��R���C�� ^Xv�'��G���H�⸒|�W��	���!Z��.6H�j(�T�=��2��PK�R��9>��`�I���bьC{dU��
����D�t#�j�W�h�e�����:d�{T�<>CCq!/��x�q�I�蕳5�� j�U����zuZ . Ҡi���72>R�(�|�����k��N9��K���rڣ���	�;����O7��7��'Q`)g!ݗ����t<��z8�(���Kw��"T��E8���!�ԏՒ%w�    ��_�%r̮�n�_=E������A�/���!����u�a�|�7��@5�!R���8L'U7H�J �jH'n��f� ���:��A֐��K��Z�����5�%�!������:T�y�1��������Tw>tH�*��c_
>��}��z�*��E4bf7��WY�E��\���8��W�%_&vHI�(a�&��&H�'��f�7��M��A�֙C�GH6�9��m�z�mg�b6�y6s�|���i�ͼl�P��o�&ny1H`����<Ԇ���hx4�_\���9HϘ1CƂ�[�⧛R1M�neD?,��C�r�d�g�|�fpX��@�D�ʯE*R���^�8����8z=5�Z�8Ƙ֣�M�[��CW�ؒZ��@����[q�wsxEȹ��_�V�e��	x��z�V�sz1�(;� ��d?����0D�!8�1V2���C����*O²�TןXbUǯ�����e�|�8�?�%1.�{u�_i��mɤ�s
��6d�N���
%U׷���_�Y�~�L>�.�V,����B�	�Y��A��<�C��DlZ�&:#�������=9�/��S9$5�w��׈��s��$�Q���Sw���F	Q��\ֻ�n+�B�k�"�@ɠܤ��G�G(�P&,�n��S��0�}�1��4�v���'���R~3��fݪB<��ܬ�\�錂��k�UH�[�Y7��j�����R�C�d�?�?��$!��C��06��}!cDR�{8��_ΥN��M݁��+�r�6���� 5��d �yJ/(5���r�i�#�@�4�d[>\
��z��B"�`�&��б�t\�> �J��߰+I%���z��z�߽?������#�#W�Į[��� t��ck��.D��Af���u���u[@-�Z�
@��j%�Q_C�0���\��� e1�5R]�&+���� �
(�W0נZ��K���vZ6`呫��}/_���5�6L�\�$��֘.gy�z�>,Y�x���_KG�WM�Z	δ@��� Wz��)$P��I����B�Z��r�q�HWP���׹�)΋B���Dw�?v����?�(������#mC�����e��CZL��No�1ˍ!*O7W�쳵�lW����<l��?g׈{Z���O�k}����bB�,d����(�Ky8��|�B�ꎗ�26��7h��~��3?�v�o��ec�\�[HX�D�`k�3#�E7X ࢚�q��n����l�54#��r|��N�������)��u-vż�|5p�#�/�P�cK*����������]7F���Lv;2ɖT��Gj���U�I�9�7�}���&��yj���P�%����ë:~��U+,��Wm��(�R��'�{��F��K��A�G��(f�E5���ަ��qx�"Le� ���?�fdwk��㤜%5_^�������D�|CʕD���.�y� =x��R2�r�[��E�ʒt�*������~�����3%��"?�l��qpy(ƱD~��-�\}�%�2JYS��v�g��4��Ft4�M#T�t�i����S���|�5~�c�=���É�f���x��x�l���󔧺ߣ���
��l���SG�8�3�{?���Ǚ��)�<�zQ�+m�����}a�;�B�_�a���=d�t���$�2c�$�@$���O���a��޷hb��4[H�%ø��ni)t:i;������GƖ�A	akʲP��P��lu�r�dF��ָ�y�	<��%w�@�ڿ���W2�}�`���6�4�q�v�3�3r�vN�b�����XBR��<��9��+J| _���j�$I��0]�#��魥phӾ�i��,m��i�.U]��P��2c�g� ��i� �4�7���)k�Hu�%�*аc9��%Q������Ӌ��C3Z[�,�S����yќ��jI�������q�����j�(�ڕC����	���x/�o����Wk��2F������z��F5[���c�m{�N��C!�:=q����BR̆���g`_l�r0KBs��hS��l���u����㴋ȫ���ڋ���b��=�!Ƿ���a����A�D�����������w� �T�w�]�!H��/��;��t|C��!<�,�"L�r�C {���@�ά
�r�T��~o�ߗ4�tq��F�A��p�;�P�P3P����KD9�ߎ�ET��݋�Zq�V�n�`/nv�����Tr�n��1H�*|�Pn{����O<!�0�1@�s|��x>޻��ѡ�� d�>,w���[�e,��X�����G�<�l�C_,�`���r��U9�GR�!�%�~�j$�iUcÁ_^����xH���Q�19�{} /#T� 84��ҽjUr�b�:^�r�-��@��
� �y-6RP��~5w���y-%E�p�|��>�14��9�jv�)F�y�1
̴=Ƞ�:���V!�6< >�k>���_�$���i}��k!ٲ�|���lȢU��r����:�6����t� �e���-1�����7�?x��7����߆��=�1I�֐B����!�}��EB�b�扷S�)���]�"�U|�h-?p\k�����	�������-͆�E/��1���(d',+��퉇OG"��e��"<(��:�娖�F��f�H2u۲4����Q�0I�Vh�oIy�?v���|�	�Ԑ�ُht�ޠc������q��P�����j��s���3n,�Q�=��SR]0���"<vs�������ؿ"��3N��R��y�^, ��qj�U0N�������w���s�'~�K��F��`-X��-�_j��KC����Zk�&�D�d	
9bj�̙c�(p�����q7��fK�®?2�΅-�s�/e��5��z��w�סq�H��+��8M>KBed��fa��������,�m���91�Cݗ��;��5#�A&q-xi5HT�w��x��]'�c&D��-�m��*��Ԙ�A���/^���Z�,ZC_o��	/?M�76�V���C/L���xR�f2�`�P��Q�r>��@����0�{�$��8i~h��64�6�=��~�x$
"���8�_(��`9��1�fM���h�o8�е��Pt��D�����S�Kg#,!όj|wN<^��׏����+�9C		����B$ա�K��i��oJ�	�2�Wlx�3�S�,pD�!�g/蟮�,��Уr�Mq��m�Ti�Es�D�M� �#]�T<r��J����\83w&*������,ZG�xN�h��-�a���d#�
Q��V�6���E���G@�C.�p]����s����݀K(�$Z��(n"�|$"�5N��WʯV��]�!`(�Z!��j�ZFx ��R7�����<�0j{kf�B�Bz�@��fn~�c�:̐���w��=.����Gq�!ƾ]W�k�<寷w��"/$��������\�j`���i^��;�������Kqˍo>]4v2I��W�~:��
��=�k`��&�� �oYSG `�b�\~���:�Q��V�\��dV�_f��%� �Fv�(�kB.�B�x��n��Qp@�D�)���=�!#�|N�z�b�(Y��׆���p>�[�H3n{	��3E�� ��+�U�Yc,��TNϐ�$�]C�.kA���&�&!����Rv��z��]�^r�����F8$-	�J^�����tX��:�~MF!��˯�����3������Ew~_X[�e#��<��Cfm:�@xh;�k$���ߟ_����J��z��x��LW�U~H����m����l�]��y㷠W�򸌆����:A`��\;-SΥ{m~G�!}G��9��T7�p)�T��F�եff1�<���#�����/�dP�N!�J��:��Z_���&[�e�G����Tb	"��3B|�z��o���Z�v��>Μzd��/�Z#�ڨ!��&:    ������a��I��
A╖�鑷�J�5e�N�[:�Όw��Y���R+���ȑ�hĺ�pV���a�wV#[IZO�26�s��J?&&G�B09p��_a�#$��	!��uRђ���zHv2P���7�d�4T���ͳB<\\C�"��z�I^������������>��-����b;"�㌧ �% �_T� ��e
�5����	f�Y��zO���ݶ��:�6p?.�q`�g��x�U��fV]^�Ay5���d����=�@�}T��<>���{U��mS�zɅ�aҐ��q���sU.?����n�XV�6�r��4��S5hEN��q��[CʻC��� �\�)~�D�0|���z�կ���,��8��?��x\�Ӏ�1G�^�mĵ�D��>��V��<߃�Ρ��a�	S��$��yߵ�F�Vη�Q1@���@��?��'V�X�'���/��v/�W�8��jX"?�gMˆæ)�����㈸�f�>QX.�7�R�4�i՜�� ���@)�5��}D�,��U Y��O��bXxdɭ�ҙ�������>j�*�����n����k�Dk�� ŵ�������X��9�(l�Շ�����=c��7qɱ��g~6�m���v�(�Ng��ռI�w�=�<t���@MX�Z��ռa�:��T`�
Yg?���]�)���V<������m@!isZC��k�� 0/7G��|_�i��r�h ٸ��1@oǙ�
h6�����֮��ܯ>�9��v��y������@��R�WT~��!'І4ə�'D�E����;~Pk�jL��t��c���ժw�A��x�'��Z��K�Q ��f��d	�GRt�].��v8Ψ}!9|@���fkV~������� ����r��z������aX��K��)��E�<،���a
x���3ҫkh67�#���+��X�M��+ߜo�;s���#�y�"S��g��/LE��R�rPb� �?!�F>��m��P��La�Vl��Tp7mת�]h��Nݴ?^W�mm=�`p �5�����o�~�/�x��x�����e7�챺A����/d��!���OǷ�
���1gr��{�-x�%��56/&��[csnm����j�)��5A�s�	Xb�~q�r��r|�x͌�]k$K�7қ
*�O��"CU��g,9�{���Ts�$�I΀$���=�|���2�E��p�k��uc�,v_ +oA4hM���.��BƻB([W"�����
���p]�5��C�l!���_D�(`ը�2\��bnӁ(��F�����+���qeN$Iͭ�R��~�R��qZ���T���s�`ݗ�c���+�I�@�q88���}����-ȑ�V� ��kI:}#��@�uX(�Hr��t���B�1�v۠Cک����'�Hi��ȧiݱ �>������\�x��6Ё���������~�oA��R{!���,��4����.��3�L�v���A���x�3ƴ� B
�������Za-B�.e>̇fK�eQ�P�3O%��1~S���� )|�akR�Z�I�t[ � 0y�U�am��j�ն�g�Ϯ�i��kW�������.����p�p��'g�jn��B�Ak�=���Sю[X�B����գ����m-�X�T"��Nt�Ƽ�#�,��<H�_6�)�'-��@��a��Ιa�In�*�ze���٪�����:�ɕO���S}j�+�� 2��V��O�*�0N���E���a�T*�7s��P��g����.W�D8��o��6�a���01eY��н�R�f|��/M۔1'�qNE�y�pQ�o[ȑ\[3����T�G����ί���w��N�@VZ&�]�O����8A6���q\���<I0XFK�1ô����|��Ek�5�� 鬀tV��� ��/��,��,_pi�u������H��.��/ܡ�z�Q���bz�DD�>��p=�KBj����P�m(�]!��P��@^����tx�e��e)~���!,���eOJ��M7.�A$K�Y��� �w4$�~ ��V�7x��%�"��!m �����~��x��ϗ�ԐFkC4�x��� !�r�|��u獿\E�b�x�i A��{|�]�����8��$?�/^�&�$e�X͂8�`��ѶY�𴵃^�����t���$���g���sy����J�|_���\�鄌���z�E�%�����9����lU �Ց,�kh�0/�����Ս�9���9�޾|J��%7SU����C��
Tr����������5�� ��rH��j��	8 ���8!��� �x:�
}3��Cʲ�c�A��nR�N"���)�G�M��#O
���Z�s&�(A����t�AE��|c�k���ө:K�^�[O��C� X	��/��KN*�����a��� ���K{-g���Q _AL��~����8�V��%�)�P%Gڥ~��G�O3<��ç�@�Ht<�g� �^�au�M0�3�	�	��淯j;%�/��%iؽv���8�
�CB+��B�z�� �$�[A�Yp�p��@y�I���^	��1F�I�B���<E�-,�Nr]�Ny�<��jBߔa��F��QҶ4|}��2�pd��x��I�L�Y�dK�cl0�0�8eyn�Ne�H$�fX�~���ek�mQ8�)����};��ק�*T�4��$�(�'�?�6Q��g�^-�,��Ж�)p��I���6<��M�ѐkk�&im�[��
sf<d�>+����}�?`���=���f���>�����vQ�o��3MZ�����*��	E�����p9#��<��{>H�#B��`�
T��b#��{v������?߂pI�D��V��-=$w���ATD�¼~�wTL3���w �ш�֤+Vr�s�XCl�(�Mo%[�4m�H��md��\�����U�2�|����m�����}m�e�"�9[���V\��l�.���o&���jkfj�j�����i"�� �4�W@j��[)Cڞ�uJ������[a�eu�['g�ԇ*B�Q��lz�����me*�ĥ����9{w�{���2jF%Y)^�<D��@q0��Z��ex�᠀��ڞ��VU#E��8F!u ������}U�C�c�I�լ����qT?Vٜ(�5BWc��vE���8_�i�
I��
�(I�dňn�Ѝ�����Ԋ�9��E�B�޾�����l���������|~�ŷ��
z�7U�jS�c��l�R�"�b���f 
2�(������ٌQ�9�J�W՝�8M��jk������Uf�Vta��̦[�]�E�俌S����-(���7}t)P����n�|�έ�[ ���n0f���A�d�Ҧt��I�>_�������9Cyv7k�V<)F:|�z#�OZ��Z��C�ٻ[�j�W8|��;�z~=�c���x|G,.��ṽ��
]�̼6ٰ1^�|~W�ܾ��JS�Iٟ7
�� eL+/��1�Pp
�u�w�ĥ��|ʎK�HU�z�2�a"�Ԧf�٫�N�g�ɖr�_th�KNTC�����=�� |��;���rߜ�3#�'"�u��_�R���jC�	b��ƭ1XZ��9��#�U���v_����mW�m�A�8p)y}����Ӝ�G� ���î�����s9p���������
��s2uCT�
	���iZ�B/g��8v=�&��8��-�e\w�1�0`kW�o�����G4�Rr+�������w�+���m�h���h~�C^Ҽ��;=�q HM�7�g�	��ȼ��ܚ.�8�/U�kg���7O^��r �p�q���m �/w^��]��s)s��ȴ��r�z%���[-��N��K�Kt}"��̣@bc��Fq��(C�!5��a�߮%ޕT�&E �PDF*C��ĩ�9�]�R2��6�s�/���R�4N6s}�=?|�z��XI�s���6��� �0��ـ��')c.h͇���O�    �dՉ�D)c��!�Xay��c�`u6�/� A@�sBF��L.G�ϿJGk$	L$E�q�����������8l����zr]����E�e�� 7҆QC�y�k>�9�u��I�`4�@A/�8��>�>Xd)�H����������MX�o+u93�h��vJ'y�V�ŷ�fD6���������˕��3R�)������ɲ�:����|&r��A�c��� ��M�	�h7����a��\�ޅ7I0��JB�v��+?�+R2)�Ub�ЃWm7f�������"������U����%��rn�TJע��(%�WD�nKd�a�#:��nդ�Ӄ\gt�hp��M:\8�sM�^2�+BO�՛^����C�����cO��?:!�i�����>[ؒ�I���
��Rp�B3U���xݿ�����]�&Tj��`�A\1�]�\�?v�d7(dV��L��qF�;"�b�~���W;U�)pl���'`v]�S��X`�?��Q�g�Ӊ+�M�6Z���9��z���]��ϳd���v>?xi��:�F[m�+�:֩�\�Ԕ��s�e خm����ʭ#�j7��x�?��j{�;D˳OY�a�Q��K������*M��TC.���� SJ"����}��^�,/z����>�îno�n����K�-��ò���XT�?�6,js�1Pc��7r������c���$�D�J��%~�Q�M�����f�K���{v�s�dȃ�BS��KQF]���Od@bG�����xoCd�҉���!��6�2���{"�B�� �1rg �*�A�1���1^~gp�G�7�r�i�{ϻ{�i�Ѥ�������+SG�L
N���o��w3�*���7FP������ '4FZ���1��q`N���8c�I�����;��V�pw�����&����x��t�|PB�0ی��5��f�N�!��뢊4����B68�N$�靟e�jJd�h�N*IUl��ҿ�wB�N�oq�J��A �����#��:�~$'_ y���rx$��n$]%ԄT�tc��3��M�iH�_>g��Z�<���=[?h��t6�W�<zfk��g��emA���8��l��yU[�&�#wk�ugz�1��� i���0[��ć_�F���ؔ����q���$?�2�`s�#@�æ��&��g��M��}CUej8��;æ��6۶��#�
4�ah���
?�:NH�l>��Mp����I�;����e?r0��$�{!b�\����G��cT�ɘ;ɸ�r��U@4�=�؆w�2$cN�Cl�G5D�
$c^�!PH���Hy�#�jb�6�b[oh���PD��ߒ�� !+��~{o����D���n/��Z*��ʠ�tsr�� �B����#@�J��2��W��G��]�!�q%�/���D�1�r�p���q���0�%!�Q��ێ�P�q��(J����t�9�1��4
�� ����ya���\���;&���������]�c��(1u�Wi�O�h1D�����(����o��я8�i�5���?<7�_��!�����R�0[\uBҙ����k�p�[v�.�b^$h�$�;�l=�3賐��1��,n=�~����0R�4��1��>�`iYDi�D)�9n���,�29��2o y��@�������MC&A�ԗ!�H�e�)ݹ��h\#����m��R2����KN��o��4�/@6M��an8e9N�A��ɭ�Q� oT�*Cy�oen��G*`�N���G)�3F�Dk�,_5Av������AI�A6_Z]��c,7� �{^1Zٛ���&3�b��5G6��#�Ac����ݒ;�0*��7���T�E�gIpL^��귴F	��,8�$C2����A->s��!�L���cozÙ���44��{�%�h��i���!�u;��1Hl���8WN�oH6'��-MZ��d�9�ps��쾝��AE�U�N��s2[{v���a�EL����ڵu��ow�o��,�I(��k6�oM(���a�N`������</+��Qy��6��_m��n�'!D�����)+�!NÓu�@K����q�m�W�d<Y��jmy��-���p6�l؄�	��m����O����#���d{q��.��'kŞ<�ȓM�g_��ȭ������v8|�0Դ;�DI4%RAQ�!����_fH���>wa���P@���VHܸE ��o-�W����D�፵�����9('A�}
vqV�7#�w�L�/�?�p&�Fpf��3�=��19�qxhr��d�����������-��&�^~�G�8E�}�T�� U���	���q����?����ط}Rë^@Vz��4�S����7��G1�]Q��)̒4~�0��5��v�_>YKM��󹜮u<�|�!�ٖ��m����2�ԉ�0��d� 2潚���9�@��@nWhF�t*���ph"<,��e�԰�0�F]`�=�r��z~�{?�+�_�N��u-5p���p��2L~��O�4H|�m�+,r7�èH<u�l��(δ�*P@��371�/DA��.j�e��>��_�_q^F*l�@r�8��nZ,c�+�
��MP�x�p�Ǜ'�K ��W��o}_:+�K��6�NQ ��	��70��냦��_��ڽ���{�M�If��H�oe,4�-��k���%�7f����pH�%�3��l7��!��[�_4� ���['VS}tv��p�Mp���(�p:�A�e�|�6��	��C@��w<�n,������_�g��,,�� �J�\�#��$���TMP�2N��dLu��[�R�Q����+4p��N����B�/�	m[��ʄ8[h�=��'�4��R� M_�����$4OdN5@��Ei���F�,�%���������w��kw�$C�2� ���0i�X8�&8���׷��~{�S���\����6�1(޵(ÚT��ߒ�%��pC��V��

��
i�y�ܦn@�Μ��B�C�ƻ�/�9"V6!V�A��"�Q �q�t�$����$���xX���o�8�iQ?	���,�Ռ6��:Α2qRoW���F
n(�������DiyX��>�
��ti�8[1��A�E�S���x���H�bo��lL+L�Pf>���}sa&��W�'��Ŀo�?m
ܴM�k�qp��p�&*3	�Dg>�;��8"gS���_��82�Cw�+
m	`'�e�+v��e���h�f3�XQo-D4�
�I��W��>��:~}�"i�U�1��̓��piU�K��)iJKe�O��\��hS��Bu8P��}��9Wʠ�T�O��=�u����V�Y��s�,�����ʖ06�Gk��>k'1���}�H�NɬL	jWylU�Ã=Ã���&�:��i�6��<�X���Rf���:�d|�^���f����b��>�9&�0W�
����r��kV��U0���V��Kz�ЧR�Uj�+@�ɐ>7\�3\�e�g��p2��fx3�*�4�Q��@������ #C��
���}�Of4��-�Ȅ��-v��̦1ά?�%~᧘��z�ۄΘ�ډ����o������l1��A���U���j&~�+��r�8�
���$��|�B�\�׳�x�;�9�%��o��,a�xo�]���3�H<�@�>�~��tQ) ��L,���V��1��LQ~_�Ll��9������)gh�$�f};2�"���V�W �Ĭd��i���P�fb luR���@���8V�aq���m/X�]aR�{��6��``�h�E�`�����
�`+|O_u��͔b�U�S[VcB�݀	q^�սB�#���c��ւ�}��n�q�+dh� ۝���W����%|�$��� �ӺY���H���������W�QؔݶT�	��19��:`�P��ʁ�O�-�ث�8�X
����X�UHp���26Ff`{���7�������^�C�}����ҽ�g�tW7����rvu�F    �@�HpTP��5�����k�z<�|�!U�K��r@���\"��ew�ۥg�l�u
��<�B��J"ʪ��u6	G�ʋ/G���B�R�[}��s�������a�����6��7At�P~^�7�EF4��n�5�E"��`Z��]`-�W�3?�!2à�G�£G�2�&n�=�74���p�T�f,RM ;�V�fA�����w��x{�Ȏ�����y�5��o&9
�p~����4y°�h��W�5�?|.���x)��8��R�G.����~nW�l�Q��[]��-̻�[4MwM1�-�K�l҃ '��EYY�,Uz�Zg0�h	�����Z��N���?�ox_��z`���B�E�������P��x��4�¯#U�	N$R̆~ݨ2[sc�/M�T ���!��]��Ïs�;Ƕ�/<(h��aM���v>��s �ޝ�Q�I�x|�۫xD��L+�xT9TM�ud�̾k>R�OP��>b���t2�'ӃD��u�#V��pÖ���ܿ�gH�
�n�rL���f}yl����U�]Z�T�⵱#2hH7O��m��rLL
_���n��x
��;����+v���6����J� -�+nc6�|or�b�N�jJ��d���
a�;V+�0n�-�U�,���h��C�n~M8g��[���n|�3�$�, ��-{]O���'=>�c���6��F��'R/E�]
j�o.u��_���Zr�c�`��w�jYg]���6.V�-,�	��	�����f4O7�q��@�����:��y��N�P�R��j�k����Z74��0^��~e}���^�sE�Os�W����ȸ\�_֋������	��\,��"˱��$��:���U~�1H{x� �ۅ�ْ�
)*{�M("�n��nϐCU2!��.���$1�DD�:�F` �z�~$���+��K��+^���s�"�����$���ų�t�w?��w��o�;�P$S-�	��y3��j��wGʘ�2%�����`�q��[�|�O��~T�k6/����đV�ˎA9�S��4r5�ҶQ3L[9t����
�Ϋ��%�$�F�D�s���bG��q�%��Y?������fO�����sA�Ńj���%?Z`nޡ�^?��g���;+�.P�=tJqFys�/����}pd��˞��!�qveo;�O�	$a��?�\:B$Ty|��{D�C`�FS���ka �*����HD;��{y;_s�J���
H

�й�p.�s�@�1�	h	�+A����n@jse�3�����@��*�3�9��$����!�8�Ib�@�% ��r6&��\6�Ȱ���l�$)�� ��N��IEX�l�*<o��A�g�9_���l� G����K,K��@�]�>��	;L�2��MX��7^�����n��o�D)��pZ��tb�J��
{�_�$?K��%d��-�ޓ ��~5�Qbg�Eq��!�pc�jK�L�Q��������� 0��n,p�>ğ h��-�Z����
38u�P,VP��wAF;��>������]�?�q�����s C�`x;�(4$zݣ}wi�aD~tu��@����^1K�/�nC���q�\���~G7(]Y�V��X��Sт���0��(�m8 �0�pI\e%D���W?p��A�-t��~c��A��O:v-��\�;&0`��Z0��}-��_��(/��6�#AZ,�M�VZ�1I��:�E�ų�����G�T>R9:�Q(�����!>���n�%O�C�s��Rk�K�e�8�{K0Hՠ�Y*��@�1b��SpH��j���hh�[�ݍ����Gg�t%����T)�oϭ��Cz�4d��{0/m]��J�gg��NO�C�S�b4Sa�'4�r|U��2�$:���qTRa���n�rm�K�I��"�8����7wGRU�Qw�-��܅Ǭ��vZ�18|/'yN��]���*�^�ڑ�#�f������� ��~� F�@G�f�S%Ƴ�w��5"
<ЋX����c���=��ˌ/.�1�rs����]be�� 'k]j�#��h��w׳�<��^]�i�n]���=7o܇�����\a�_,���&�����<&�ZP.�A�$٨���@+L�=��-L���k[�0��� ��;�o��=��g�.����w�����-�p����{�M �1q^��'�d��P�:aT�@���7�}��Ux�Ή8RL\�-�u�>�Qq�k�p�V�4��y|��_���YD��J@�cE)ɃٞL�F	�C2�J	T�����ꮰ��:y&fw~�Ҥis�?L��i#�����)1H�~I&�u6�5(�u<pI慹���E��>v�{�|, ��y%߄ٌ����g��2��P�S��������ݫ �g.7��\��?��u9�@>��[%�cNv8U��r�
8qVځ���b_n���N�vb�E��E$%_5�3%ݻ�ΚL��
��7Rc�6�����Mnq��(��[�Dh��cňxp���z�@\�y�:���m�F���la(v"9~�C(l��}����o�K<y`t@׮�T��E����Q�8b�qs�CTuG����&����U*�*a�eZ��Y3�T8�"����%��~�-��z���������&�{x\�b�~���r���n\�)L��T#����a4|%YW��Q�24��Q��bTIj��G���|�n���2�����$*���o�KA)*'<(h[���^yKi��n��e���T��1*=ʂ��?�[������|�,�y�����,ُ�a�ub���#:<�H���ˆ?������F��z���|��,ϗ��9���J12�}�#�B�
JOpD�c�6��@>�qG;�!��ئ��rW�C(3t߼z�taÙ��H��wI#�b��5���������|gΪf��0��HOy�Ƚ�1���N��.n������`G |�
1�c�Y����|�3�$}ub���Hhg�7���?>v�j�>��*Z��
M���C$�<�$�6���Ǉ��������hHv��뇚�#�}��˧덆�:;�;v������9i�NZՉ~HWE'A��|�л�?S�}ԗF5
'L��=ݬh�� ɗIV��Ox� FC�z̝���e��K,�#��׷��a΅�޽=X���X�䪣Q�\�p"����_v����R]���5}5�i�:��[�Y��AN�7��,��ߵc��N^`e��O�$�`� �Z=&����6~�f=����Y�F� 5���c�;D�C�ﰿ?/0�O5���	��BT?^�3�z3�b�H#�^]p�/D�D���5#��y��LH<�Է��m/�R0>	�!D֫G�܎���}���c�)�\O����9ߟO��2�7檨y$��<}[V����.�T<(W�7~+	AVj3�*�PH%� ����G�~d� �f�G���4��^=h܇�F��4���Nh4�?��=����[��2q)FRM��<���o���i�m��P�=&Y��������+��w���
�n~O�h#�
����|���c�]��I2��햻��Ճ�.�)˥�����:��Ժ]M�`s�A����0�űj1��!������K|�������w$	лϧ���L��L�ha�=Q�<���{o�6�9zDc�s5/$М$6`����I�+�&�`K/���b���&�����+�p�jY���E�#Ab�8&�>^x4����ff-A��@	*����
G"�3�L$׿A.��w��=�>������O���p@w��g��c���	���ޞ`�u'�{��$�Bİ�k�e��( ���8����U�Τ���S'd�{~�~����R�G6�+���!�-sы�Ҋu�{�j����yC2�u^���5�y�G�L��8��_�qN�+�,���{7�u"��Y�;Νl���D�L`��d���6���խ�=J��sܝ���ؿ6)J=�@�-yy�X-�az��y�Й/!�9�    �j0���p��ӵP�?���|rf`��)��Tq�<�9n�����.!� �~�LaU����w-��7�]6g���x��������sò\R�qpk���5e ŕ �gSp�Ik'�Y
����s��wI�91Ɛ[ �Q{����[}��c��σ�|�mz4����"��8���ojz�?�1�0����#�2�9��VeQ.�%�$	8��Q�㧅ձ�s<P4Ed_�8�|�e�u^7���z-�P�qA��n;�.��"*�f�@ɴPfJ����PЄ�j����|�N���}3�3�7�8.�_��wl�Դz�"�08�0vw�>7v<d0��Q�T+����6E4��B�8�X;�q���F�A��Ye�Ŧ¨g�h0t��o��@E�e��g��z���\/�����N���-p�9G�������ߑ��[��<�	��.��
����9�üQ������YR�-�������Y� |�k�O�^J�4���gi�(WQ\�!������),9ê�9��E5��')���=Q��2B4����$���� �WH����%���+��|1�"�"�!�����A�-��f2i;��_��d^��C�ˡ�03K��!�@4���&m7�V| �1�v�T�l�H�ca/����Q�!�	�1��������¨��Z�w<5)
⚀����]Y\���1�፪�ݝߟazyلҳ1I���D�z���WnuK�/�@t�&��Sa��A�JC�Dq��=���n%El)Uy��c�{��K:SD��í��-N=�̈���[�.\t�ކ@� �������w�uv�����6�u�*}8�������Ȝ8�.4�ƛ� .�`W0�����<��O�_���|`�m���U���@R���_gMou�r����d�Հ��e�%8�˨P����˯�t�AT܊�H�����+nl�S���~����ʆ?R�̏�~�4����q
A{���d[��PЮ��Q9Mg7s������|;ɰv������Ņ�s�!��D��+�:ڕ�	�P�Ǽ8�c�8�p����!H��j@]:��$u	�dP=�Tڲ��p��]��.j̖rN���7�����$3�ֶ�c��c._U�'����O�Z��i��oNqi&0��"/}Ff$�'�^!��ǅ���0���X���1v�-VJ[b��5���'�0�_�Z���lz �u?��]� bl��Q�jK^��n�z�iV�X���j�X�ڍ�Ӭ��b�4�Z�3�W�i`�۠�dM"��`�
��ĭ��d��/2�#'��n�Eޔ�����Ct�{��|�ץዙR+m{�Y/"y��F��Υ�5Qlq��9݆ޫX�w�'�4.�M��LqCk��;����v��_�!i��7�+�m���ޙ���C�Al�.g�o��c_P\�������*N�$~�B��Єy���{I\&�-�q��O��L?���z�~�l{�!]?��Mx����k�[��7'� �����D�	��/}���Z%Я���e!߶�:c�	� +���#)���1����r�9W��������>D�np9:�
��VQy�))6`����!.���Q(��%;���Et.�4��GC��
}�!N/[��|
�;=nh�!jx�0Ì��� ���2�IG���U=�G(��B枥�1cXɇ��0��"�hs;T5�t�+��cl6�'l��(��MN���NDD|�O'����ɾaO�X���ŭ!๐l�+�	t<�3"'�����f��[%w��kӸS� S|u#K���0�:���4�.EKd�f�����=JA�/�C�P�Iv:��GE������?���OO4���1"�C�Z�(���I�o��lKwI�E��4d���J[T����v�mWr5�t�<�Q�	}��7�μ7��y|�}��#����y&��*�axx�K�*j429-�1�~��:��k���f�'��6$'�f`?F����b&���Ic�b�a��=�k����`kӣj���{5(P�0�P3�O�9�p�x���b-C�>�u��1#Ylp�7sk:G��-y?�����k'�`+z���]��h�R���<界�god��~�s��6 r��l<����̋^���>.�_$wv�AT=@���'&�)����-�:���z�CV�s������*����<EU��Z*Q�]�Q�-�#���)^wO�[q�5�� /HK�䣧�偰�W hn��j4R�-`0�C��:�]�g���ͪ�{͆}���g�6�7d�q$�J�5E��ۮ��	5��8�QZ���ɾY�1m'����a1^9'�{v{]d��D�40�V�k|2����Q"��{�b�;���k��*3��3�J
��#���Y�dS������ %�a͙g��}z��*߇�=Y�ވ9�.8m���(��]�g3�����`�f�ʄ��Ć�ڊK��
rc�"R
��~�x�ܓBq�s����XM�Z�X+R,Wˏ�R{�Y�}�����|U.:�#�qxt��� ��E�����闢�����N_��e�o��2�5q�F��+"Y���[y����(�6D'�n��w�bP�Zӆ+�m�A�)��5X!�U�Qj#�^y,dYl�^�M�?==A�^Db &��9�_t�Xd�on���
�@Rtϕ¹ʳxW�,�D�5��X#N%a�x;A�
�����R�U~6��p�8�D�V�u�I=$�0�}�pcI����۟�����ʔ�������[� �pDD�h��A�8��A+g;�A1���TB$6s��������*�~��Po��%3�i��9�Y]�u�d��4|6%M4���qbt����$z���juo���I<RAN����9��#�<�q����z������E��\u��!A��Á?L%�ͥO�{-���>*d���N@�VF���XXg�{����ŏ��m���)�$����L*���8�X�.V�BY(" ��y=w���!B4X�ˉ(g�{�/a��Iq@5s����,����պnj�L����WT1x7��0�� �Oo9S�X_|�{�`�7 �@w<���c��@EE
��[	ٚJO�H�( <k�U����q��V�2��e�:Y�o\��"�Kxt��kQ�Y����>؊�����FZ����Hr?��M�f��jT�cDd˃(�7���{9g�T�GHI����%C��<�k�,rp,�d99\�u��ɿ�}]���U3�=�c����a��vߋ�5�1�Jx������~�&{|����a�ұ[�͜����B�RpY|{4�������P�X+<d��MT�o���P̀�أJA9����Ǌ��Z��¡M������%@8��$űr�k� �	��"+(/���?]-?�����?�Z��d�"JS��c�y�B��@��~T��e8���U5C�cO�y�)L*>�������L�Q?4	f6��_=�D�ˬY��7pRo@�U���~���Mia_5��m9-2�fT6����s���@�)�:���!x2�����< �����{?������MCs�4Ơ�)d�G�i���ɣ}���� � Yq�r�J�/ǧХ��h$�����ޣ��}8��x�8���(�|��|�o_�!6��s�#�d�yCΈ<�_8���gb�W#|�bج�����U�=�Ñg��!v{�J�#�'�����K�ܺDC?����ʥ�%h�G��C;�U�k�iuQ�n������r����hkSE�R���Nw/�� �~��i�j�:�����������].�o쮴#�������O���zR��-�i�{ �@�����nw���uy|�H3�L�q֓�zݑ�~�Hٗ�=i�w��wY�������,�R��z��c�d@�i��-Fp�A/Y�P�x(I�J�s�r��')��Б;�L+�|�����pp3�����_P:����z�  ~9?czؾ���1��DL����R�� �
<�:�t� �  ?f�̄UJ" �w�8�� �d4�f����"�|G�sU��Zk:,cd�'�Lz]��҆�MdD�qX�E6#q�r�r���#_utK���45#sF.���g�� '��J��A�_
�N�|Gһur��Î#�M�������<�[>L�?W�~}]ݟ?6�Zx�έs*@>^�U��MAh$����ot��I�3��3�跑�,q�7��_Ώ�;I6HQJe�ͺ�g� r־��dTC�P���b���:�|�U~Z��_1��,��Eb.�N�Bo�γ΅0BM��T)/�ؖq�'#�@��&�qR�^?{��S���b��ţL�5���ݽ��U�+0}�A��$x`#��Mdj��<&�)�:O3� �0U�_E�1˪�cm�'5׊ќ<WW�>�A>o�牑��|m-�=ߴWdD�G/�wdm>�B�[�y���x��G��Fo
�k�ԳʆےN:�w	�cr?V�@�=I����@j���t�G�M�gz^DL��,i�A��#���ibLm���F�N�`���\�x�0��r���:-FM��^8(��r�֓�?'n\����=��R75Q���&(�r=Zף�u���4�թ.��X�ޙ:�v��}8?^�l*���i�i����A߲�d٣���XyB�!�٣"���t�?���˞�;���E�;��&�d�i>���{i�^���/��3���]��/���%��ܟӐmL��|�����(�Q����"��%)���u�I���L��a��L����v��c�zcm��
�5e����� x�^Ba`��ȅ9��$=��	�J�s�<�	��0��Y��Hy�f�e �:��i�E�q����|�LpT�D1�-W�mĜI�ٴiT
ͅ������p���N�B?4d��̳�F1*37:i�b=�	��~0�HE���$�q�V�E�_��e�x��s1�04Ȝ��r _���@����n�����N@ ��m*��h��)���:\*�j���IhV�"U�f눒��V����L�X��+�&���E��3.��a��|w&S,�f)Vl���Ew�9CNH��3�� 8	��>���`Y\T����7Y��^�CkIz��\=�!:�]�����Օ��	K76|.�Vֶ����a�{
T�8��Q��D��3^��Q*X�7��k�Y�>&7T^̌$D�̱[��"Q�����2p����&�?�a�ڣ���È�`i��]}KrcogP�d� O2����n��� X״bJ���Y~K^(����T6)�¦k��;{�u�E�d�|�\/;R}��H0��Y�^X{��4���Ѧ	Hڦ�u%I � ���k=�_�V�C>�
�ت`c�U�$-p	#+M�}{^`���h�Dt�BB�Z`ŗX^�ԁGxWh7��)��/��ct*]x�\��v����v�`;oкX�7"T`r�8��/��)^ ��\ϵ�y�3r�Lx�	jhELN��B_x�#�i9�zBc�VO9���̦F9����,�Ƽ����^8���B\'���n#x�T���!��g6���U%�`�e�)��z�zo�3Q҂���UE��J7��{4��.╀J�ܸ���D>#�
4e@�aZ/[�&���9G p�[M4�k��#�,"�h q5�<�T�f���\�(�����;��IM�����ճrk^)���Z�t����PX����W�v���+JM�gv��7i��Άw�����&�tN6kHkz��;�#Ix���m��l8����2���>%G�$�Nؖ59u(e��XEU�&��E�A�Ѕt��H��z��N�"�������JL���#V�֙GɒCrc�ٺ��K,XuB���H�zES/BbHX�8�hܟ>.g�Ź�����ml��o��_Bo�z�U��_�{D�������?��HT�      �   �  x�M�K��(����L4~{�$ڦA��=�����+KɫJ�����;�9�s�[�\ˋ9vn�~1'���-�9��s�#���j͕�BT֔�s\K��ķm�#�X+ ���5���!vW��-h^�����I��n	��X�{?�EM,撶4r��[j��	���LѢ'���0{�D�%kt2{��u������Q�� '\K��������9��-�j��	ղ�?f���0jV��=%���#	y*y�Gs@Itȳ�怎А�9 "0���G-��1�n�怌��P��������q���!A?�怎�gHl�#�Om΃!�Ϝ��k3G�D?W��:sDLT��^kv�L���3�d��	޵�戗A���9�%��E7i���)aYODR���1ysBRLae�'$9�2'��`N�)5kB��P�r��fb_.�愙ȗ�愔�Ws���KQ����9a$�����3Fb?�g��[�"���{��I(��?1R��h��Š�	��b�*����sFG$�.���	����#��\4l��ݹ #28���؈%W�����|���5����k�.�Nn~������{�L.	*E�����[�n��x�O!:s�K�+Rs�~6W��r�ջb$��=uѮX	�^\q*n�&]Q*����`�K憐P�I���kn���v�*~�M���-�CvCJ�h;�tsCL����ܱ�7��U��&�S7q�biA��!'�=j.���'X�����΂��f��Al��m��0x��|�ʟ*�������q�(�*����{t5�����ƿ��Ћ�̑���=���~���t: �����^5nt��B�Wm�	 ��+��	 
�b��thM���c*XS�X� ��4i�h0����'VKs7�W�FP(?�.`�.��S����m�Y�!(
׶��"fi	�6�4=l{:�J֕.FۣE��3��eA֌�(�nmY�L kQ$� ������bX+���o�A[��i�8��0m�H� �%O�p,%���U�,���R�,-�ě�����{��]{KS!����	���y���w���B��?^,]��7�\�z��17���KźuyN:g�2oX9t�>i	h;�'*���,���s<~�{�I	-���O��`�BZ:��sk��~��fջh>���Vk�>��u�Li@��&*DM���V�`w��
�]��Q︯n����psIˡ6��giGd~>�����1�?n��      �      x�3�p����� ��      �   7  x��U˒�0<;_�Ȥl��F�8`��=�l���J�$��9�!�a��n�-�RZ�8�y���~vBV��J��<��x�ޙ��5�	֎~��*���')��#�p9���~1#=���>�7�#xc��Rj�*�~��x����1�L,p���t~�Bj��2+
�-]OUV�	ڀLk��A?�����0���!x"w�;�W�a+�&�G"H��]��c�Vδra���!����<W��%L�붯��`�B4PHk ^��+�ipI2K�,Yg���1]���ʊL�|k�����9������=��g'�gF?�0���pbԖnb�{�4�*]%�11�����<��^q����,�|2�=څP!+���CɤPD��I������ޙ	��%kS�T'��s}h�9Ţ�g��L������k��	�TQ��H�[7�mP@���u���>W�e7����V�բ�-/T���UW���{+cqz��rM��6��2+ވNd�GX����-o��н�,2i��ܛ�xO ��a�3C��JUΰ�{��?�����b�㳰;����{�v�H��[���S��ܸcLV�	Y�H���2�Bd\��D�i��O��w4�/��L�eQ��!ɖ��Դ�t��y��(d.�:)����p�r�RmhI�m%0��8�*����������^*]6��\z�F��+�Y�2���i4ے�?�w������j������<o��^�#�����&�L�s�bTJ��I���L��Fh����aŃ����)�Q��-؆��|������p�����	����p��ڼQ      �   �   x�U��B@  ���S88/6�p,ɬ��M�0��Wb��w��|���P�~���� �EE�9�x�مN�6,P����}{��󪳌��ǆ�˼F�:��;��B�6OTpY��������4/����ĉ� �Flp)g���sٗ��KUp��s��"���~��7�      �   9   x�3�tt����tL����,.)J,�/�2�v�H�KO/�KTp�L,N����� u��      �   y   x�]��
�0��s�}�J���5�¤�t���sL��\���ڇ���'�a ������Z�T���֭�Ũ�4��������Ӊ�	V��b��[qm���-�W�8}k&C����O��_ �+�      �   H   x�%���0Cѳ=L��@�K���(�=}�G�*b\	1����5L�`���{O�Xp��w0���� �      �      x������ � �      �      x������ � �      �   �  x�u�Kr�8���)t�ɔ ��J�t���.�驩���c����zӋ|)~H�w�0$�x��2����8_����?<X����s���`P������ƹ�.�F��{?�.�\:v	4�(ɀn9�OǶh˖}����ϧ�AV&rC���t�w�U�� v�Ǿ+��F�_�ͷ�qZ�������?�ﻹK� �T�L��􎠇�%b��!u#����^H�Hx#��PR��?�e������/��e�u?���e�<w$b�Xv=L�n�ڕ��;�V;���YVc�a�QM5I�0�Pp3l���Z2#�pX39{��� >_���&it�08�l�]�.��
W��%�<��A�K�0�œ�b �xVX����;,�C���B��
�@���lÎ׊��U;�(�ۄ_f��°!(���A6AA��g�����l%�P���b�� CA�K�lٚ\���z$�[
H�	e����u��#�D-����f��H�K�a&>��=;"�D���%����ctZ��r꣦"�Ĥ�f�8BLT1�S���U��-;���E���a��4��d�5����x���kd�8A@2��I��<F�$s�]&(Hz���;'�i�mq0��&�P���A6�\��OFzd�FA���~�,��Q��l��V����.l���lrD�폿��~��I�����l���1	d�N��+�'�Z�r]���m��kV5m���
+4N��a��96�c��mr(����i(���k�(�Q�(�k72��y<ȅU`�ԍ�J��RUK��*,UZ�w�*o�
I�)���d��t��>,A5~g�o����\�T��E���U�FO~��S�I�341����h �'3�.o` ^J;7x@��b�{���"���e$%�v5�J�1K��c��������V&4$D$a�ˠ*����q�5�Z�FC���}����|4T��v���q/w�t�h��K�a��N�$:�,�f��*C��T��w	�5�_Sщ��(�!:)�ik�a����x��Y��&z�f��2*��Eu��.���F�)JB�ML��ң�&6����'6��U$��j�uh��8�#1/<��d3�6�1�����	~��	�7q]O�(�o�F�$�4_���q����$� ���(��W5�І��k�P�����~y;��~�D�'{ESN^%2~��r�DX�����p �^E�^�К�/��f�9�j#͏V4��KBwN��@!.<�[���o��_�7:����)l������wz�p���{F�N!}�֯���S�R�h�)d�&W�����B�N�X����Zw
Ɲ-G����	�B]��׃B]4�F�������������)���>�b|�+C\4�r�L�/ �Y�~s�~�b�C~L��/��g�8+���I���9�?��k.      �   �  x�E�K�,+��b�⿗��u���N�8B��k�������_����2���W�ʟK?w���y~��G?��[��>~���w�E/5~��(���O�4z�@4�Q�0���qގ�)U��_�o{���?U�H=�o��nS�c��YR����o�����/Jh�ޑPb����!!,wm)�`����N�`�H��GZ�Է�Te���V/mS@c1|�L����~!�q�i�6/tZօA˾��*ZZ���R��7;�+C�ұ-�w�)]Sh�z6��_�Ae٭E˦yi��(lx�e_���G:a�E-�9F=��x )XGR�U�x��1��Xݘ��4�퇫	ٴ�ҳ�s���T��>+�BZ ��{
g3�oX�"#��	�����
��X������d"@r��(Ib#ʪ��y�lC���(�/mj�Ԥu��ʑ%�J`����I���[$�+�DM��'AS�@�F�y`�h�o��m6`�6C�H�N�r�s�;�\'mr�S�6�%<Ej;K�-d<y�Q:k�M�2ͤ�G*XQ&�%�0�t���S��h�J)���"���QRu�����M%*iJt���$uӺ�.��/�8̨/V��}�.SIO���QĴAHhB������R���x��Cޔ�$f����"�� "VCʕ�L�I�K�I:��G�m+d*	>�^�$7I��~	O�Q�lyJR���-_I��y.�tr�$�;�&M�<�j!�O�h�Ga�M�4.y�l�2��,��Lo��b�*J
a:�ظi�r�Y3C�;9E�t[��P\b�S>Cq��^�b���C���;�Um�dEy�j;���\�j�Η����u�ﶕ$->���RG��7Y;Go����/��L�X���o�3�\e}�듉+Z(�!Iz6^�oi0m�O�lQ].hq�ۻ�,�h{�������T�g���?�Jr�{J�f;).y����JVR�2.y}�����$��W��7^p�cj�X�X�LN��k���4�j��X�d�q�:�ϙ��\��k��$��>���A�#O��/�K��O�j>vL#'I�)�0~�#�Z�w�ƞ��#���䠩�8��jS&�*���|o�t���ls�V��ܘj��$W5��a�E2kh�eZ���JS
��W���0.XyR7�K����4M��2�K^�20'T�"k�?\����ۍP�M����ׄ�o�m���d�ʾI֩�d��+�@��H��!.B�7�*�r$28=wRu�綹�mߥ0�Kԩ�,I����/W�-�KH���֦�Ǝ.�6@��@�1=\E�n�K�kt�T���Y���ڀ�?�}0w�-������T�p��T5�OU���TY���r�Rm�вƓ��!Ɠս����v��dQ���nY�����1�,�r�5\4G��_V��-W�,<zX���������"k��D�� <'��a쭗��䝌.�c�.}���+c��w3��`��q`��z"8k*�4�8���l{����<�շ>N�jxWwM����ȭ.@�c%ё˹b�`�`I�o��l�r�$f�����p����y���:�����Z����]�h��"u�m����e���H�q8-�yC��h\θ�]X/.j�F.O�*�+�F����U�w�řd�U����&M����l�3���s#^�m�!��2ApI�y ��~ilW�'#�&���k_·aD�t��ȯX#���=,��w._�^4ׯD��q�s{x������a5·VEM��x�\Q�x�\R��T��m��:ˈ*�b\�7_���.$iԘ�&J�զ#�7���E#ֹM7g�F��J���$�F�΄�X��bۯ���u�҆�F[��Č�FM��H����j�y�"i�Q�8�2�e�����ȷ%�D5J�a��7�:��ՀW$-�L	�b#�s+����<�� ��Az��C�J�����.d���S��s������k�� 9��h!c"�,����㝼G���8��J������	:�hՇ���=<�~��H#���Ɔ%��h�U��>iD3ȁ���l�ސ�9�ѝ��5�����ow�w6����D�T������,�}�o�`�7�؛��d�\�d{�26�P��T_�f8�����M�'z+�p�{����K�Ot��F�0�����D'����UXǨ��F؉J'n��I�<8�C��Yڅ����o��X�q;�t������	��� �\�}��A������Q��_)���ߒ]      �   Z  x�mֽn�@E�z�]6����.ҥ�y������Q�qa,pA�4�����~x�{��?�?C%(q���(�*����JW�~��2(�*SeR�U�ʢ���q���+���)�*�V�;�����L�[�A�qM��������������tE������ం2yVR.�y�����ry8^T�s�/*��p���.�E��ぢ����:5.G�Kå�h��CG��!��#j�G\����Ab���T!�HRq�8���#��T!����q�"��h�h�G�F�J,K�FC�ei�h�K�hh�M+�&����F�FC�J�I����4i44X��F����4�vI�[���K#n����F*��F&��Cj�d0"5X2�5Xg0����K�{�'�k��`���:�q���Kz̝���C�����wi�Ibdi�E���4ƱK�F��<�1��{eHc���i4؇!���0�1�`�4�Ð�@�}�h�S�aJc�.Ic�4
jJc�.Ic�}Ni�ۡ/�)��7[4�1�.Ic�͂Mi�������B���4�ޒ��]�ƺ�J~Ic�]�����|{>��#�8      �      x��][%)
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
Fy�Z�O�C��|Ɓ���&�6s<N6?1Rv���/�N�	?�κ�e�ېI�5�SJ�)��p�MY���������D����cגe�ʪ�us�
����8�<��#�:���~����Sm��Lymj1n�u��/��¸5�n
�\T�N�a�)�k�r)�1�uP~��� .�l��J��vQ�l{�DIT���~��z������|�	�Iv���sk��J��*�\�
hH�S�
���t�#�c��d'��H�bxZ�����gO���].&94Y_���i߯����V%l��x{[����{LbR���g����z��#�����؎���\�rȘ�~l���m�6l������/�_�Y��t�g��(��=J��f Li//���}��Mt� 9�Ԫ��`�d�����2��JU�����l�� $1��Ӌ;��#r��jB��/T�����<��?d�z�8�]W͏�{��#�~Kc2�⨻����p��`۩d��� ע��䞄]	/�q��
OXM8}��L����Ōb��A�e=�a�'��qaS�b�4��u9��Վ���)���-''��T�ۧ�>�����G ��C�>Lwb�K7)�����k��!t�g� u0�Ӑ7�R���>��R�8�SO�8+�ǚT���j]��(�6ST�jw;�P�/��r�˝�l|�1�*7��e
�^n4� &�\�@!�8{s��\��ɚĨ{�U���ꛮ�/
�� g��M���\@`��u��;?Б�&�J���o�:����\�ݮ�����ZS���yq��2֘V���l�Q��Wxn��;k��+�MF݁H���}w�8�Xt�� uaBS�N�hk3*��Lt���kZd9��5io�w4��	�Oq{#LlX���*�������t����Ƅ�K��M)H�~�&��
T�I�1V�x�ر�.��ϞR�Fҧ٥��e�ޥG�����8E���x�h��ª��;%����Bn���س�����R9e��(?w����W��<j��v��u ����0'�B��b�`�APΰl�н\% (.(�����>h�hl`���E71�*�|��D�ɱo.���xY�t���8���~�-W�1	�Z��=�<��nB?��';lY�Yy�"!�S�K�yP��)<py���WR���AI{ώWY�������==��쨂э�Q�~=.\�*������Ǵ;�Q�	H!��H0����k�*�M\O�O�r���W@հ�r!����8?l+���b�� M z��.�i�]薖�ԩ�p�j�Zt\���|�{��Ƒ��Q���Q��(��	�C�&G8�P���C�&U
8�Po�w�����"�՟=�j;��ч�:3��C����=ԛ�*�����&��	] �5u��JL�R��� ��7E3�а)94Q�����N�p�%[:0�dG^��s����B(tNǂ',��P����-��xa67�`�Ae��Pt���0O�m��O�C�a�G�KLI�Y˩X]TY���[����+����z7bR�}8��Y0):��$��_[�$ ���0���f05��xx~�Zt��j0���.F;r� �����CtÑ�H��sZ��G7�.g�؂��K�G��:^�B�-X��HR�n����I�rd��I��T7�`V��8_�{Q>f�)�T�$]�_�3'U64��:��n���ߊa����(LWQ ~�M�����9}�I@�&����#%X�� \  ��
��pvc8��uGF9�(Gi�
�yz��HN������4��[��R9)T��I���I���j����$T��-BS��(Ia	��$_oK����>$��Qq�ć�]����X*'�p�*��'�&�r��w�: ���#�9�Ԭ�"������v��fTxb�������Ob��kj�/ؑ{@�u��~6zW�e��O��+Q�n����PB�Ѭ`�!���r����}���j��F\G���8��)�O�5/ܫ	��=�Ii�.��G�-����I���?u6�j�L̅Y�H`�G]dس
�㐪�=JW@Z�(��AR��N����.�+��42^�`3KAc���v~Y�Sh,
�9�ᢐ�
�E-3��p=H1:`:L	�Rx=�;	�	六w�KV�&���5�{�?p�ޯp�@B�(�G$�+ā�~�.9��o�-����O�6�n��_����1�������A��<F�{�}��I�zj���w�Q�u�
3��n��a[]���.«�����>nm���I�zw[�d�.� 3
��0|�{.�A�����!�\O�G���F�6ɇa%�󝔮I_{ߔ�[�1��1l���:!5'�A��؇ދ�kZ�kR'g�����wZ���,�Qj�Oª��擒��"��&E(�7R�"���$���Ѕ��k�%}v?�;���Ρ����:�O�b�&�P3(��C�#[����fua�f����f�	�=�WN4S���B�}����&尽��R~l�[��	5YpsݯL��N{S�X�n������jQ��^t��nvL�O ��ω ����j�N���.��ע�8��]9�0n��8��)A�w~n�,��zS^\���!}�U�����j*G��1����X�>s��렄�Yp�Ñ��_��#�Yq�̡�q��@����~�Y�}>�����N^�(|���Fp�����qD|�b
U����*�~U V��&V?7I�o���RQ�����5p����� ����U��*<�>2F\&U���V�S��#+���1M/aⰃ�j���JxW ��C�qq�~��U�K�k%]�^Ibi~%�o)t+N+A�H�&��I&��.+%�|lb������ޠǯ݇~+Zl\��m\s�W�y�xR.q�?��vU*U�k�
�a�����A\�؟��#z��X��!L'�{���d/=֖LE���L)��\	,���c��L�l�e������hb%���MuS��62�v֠����XU��7-�>���o�)�؎��J�s�~��e�\ƅ�8�`�@ܜ�v�	���{y�>�r���t�3{2e�{�C<�uD'36����ݏ�n@��KW�:}:Bi̹)��V����z����^�`ucn��S�b��̀�n�Q�b�:PA5�7���ҟF����R�Z?�O����s�d�}y��YO>4����d#�=OI����_��PR�4����2J`'��ԭz(K�R�.W����~���єH�D���b�디�Ԑx��|㕛����i �{��C���VN9��y��DY��Ќ��E�6O(+DC�7+��3+��5< A����~��I툒�(q��v�u��=d3�5�5K�����}�O�����&�,����d�_�'�]=9G�rꨘ�kQ�U�HE'.ѣ��(Τ���h��ܔܙ�4�@d�q�v]9�����#Զ�5��QIc���I��=�F�(�����S�&M{%}��1�jvП�M��Q�:p��2����|�aQ�S�ˣ�4���o��M/���K�m�ق50>ֲ��`�¤w)<4��a�ay��%�Q�P����ZP5����)/.�i�Y(S:FN�����+������eH���{���(ߜ��3�GJ5���r6"Z;"�
Q|UĊ��I9XqI������K�p
=:��;�T���0*GUq��d���G�.�$ "���0�b�\�l�%��(ۅ�Љhы]DNب�H�ɢ6a�^��3��cB}2l����xK�����������j��vVQ��I0�)��D��55vEL�w��~�vR*Pq6	5�)������h��E5*|�uZ�
T֦ӧ���َ��x7է��xp�TO=�nH��M�+;u��K��F�j�k�޽�S��Sհ�)�G��M��.�iOf{\]�Z͊�q'���Ta�F2U["�a�b
c�4�γ����l��d���Aiƃ���`��T~��؇�}	��2��{z�m�{_���a�Q��p��K馼�7@��{w��q�v �`c�@d����!P���q��q����l6���R���l`��^����ګ6�0�E�E��=t_��|�dib��ږ�Q��7��e�*U�e����gG}X����ܿ3���gA	���ǳθ�D�*���U��.����e|�[7��"���ܖ,n(�LY0-TS1~(�:��Q5�ZIJ�6���6�۫j%ۘ�R�u�齠b0�/��e�N"̲#�T�LQ3�V���c��u��Y�T�}�z+
���Wc�V�9j��	�I�M6��_rs�x|��$8c�M�*�Hbko5���9��k��́���<d8�2�E]u�f�1�:4�M���`(et��� ���o���#��aQ�����Zƣ"��]�/%ۧx#�h�~�⯨YCUG���Ge��+C�f�S��{q��@e� ��p�h�m� �d*YUL
|H!�U%���:����*ٸ������k��J��r�-./�Z
qbX��T�\��QQԪ��_��cLe�8���n�/r�[]�1�֫%��F��?�[?���J�q������1�zq]��������J     