CREATE TABLE "Productos" (
    "Id" serial PRIMARY KEY,
    "Nombre" varchar(255),
    "Precio" numeric(10,2),
    "Descripcion" text
);

INSERT INTO "Productos" ("Nombre", "Precio", "Descripcion") VALUES
    ('Producto 1', 10.99, 'Descripción del producto 1'),
    ('Producto 2', 15.99, 'Descripción del producto 2'),
    ('Producto 3', 20.99, 'Descripción del producto 3');

CREATE TABLE "Usuarios" (
    "Id" serial PRIMARY KEY,
    "Nombre" varchar(255),
    "Email" varchar(255),
    "Contraseña" varchar(255)
);

INSERT INTO "Usuarios" ("Nombre", "Email", "Contraseña") VALUES
    ('Usuario 1', 'usuario1@example.com', 'password1'),
    ('Usuario 2', 'usuario2@example.com', 'password2'),
    ('Usuario 3', 'usuario3@example.com', 'password3');

CREATE TABLE "Inventario" (
    "Id" serial PRIMARY KEY,
    "Id_producto" integer REFERENCES "Productos" ("Id"),
    "Cantidad" integer NOT NULL,
	"Last_updated" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW."Last_updated" = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_last_updated
BEFORE INSERT OR UPDATE ON public."Inventario"
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

INSERT INTO "Inventario" ("Id_producto", "Cantidad") VALUES
    (1, 10),
    (2, 5),
    (3, 15);

-- Crear tablas
CREATE TABLE "IngresoProductos" (
    "Id" serial PRIMARY KEY,
    "Id_producto" integer REFERENCES "Productos" ("Id"),
    "Cantidad" integer NOT NULL,
    "Fecha_ingreso" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Id_inventario" integer REFERENCES "Inventario" ("Id")
);

CREATE TABLE "SalidaProductos" (
    "Id" serial PRIMARY KEY,
    "Id_producto" integer REFERENCES "Productos" ("Id"),
    "Cantidad" integer NOT NULL,
    "Fecha_salida" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "Id_inventario" integer REFERENCES "Inventario" ("Id")
);

-- Función para manejar actualizaciones y eliminaciones
CREATE OR REPLACE FUNCTION registrar_modificacion()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' THEN
        IF NEW."Cantidad" > OLD."Cantidad" THEN
            -- Es un ingreso
            INSERT INTO "IngresoProductos" ("Id_producto", "Cantidad", "Id_inventario")
            VALUES (NEW."Id_producto", NEW."Cantidad" - OLD."Cantidad", NEW."Id");
        ELSIF NEW."Cantidad" < OLD."Cantidad" THEN
            -- Es una salida
            INSERT INTO "SalidaProductos" ("Id_producto", "Cantidad", "Id_inventario")
            VALUES (NEW."Id_producto", OLD."Cantidad" - NEW."Cantidad", NEW."Id");
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        -- Registrar eliminación como salida total
        INSERT INTO "SalidaProductos" ("Id_producto", "Cantidad", "Id_inventario")
        VALUES (OLD."Id_producto", OLD."Cantidad", OLD."Id");
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Función para manejar inserciones
CREATE OR REPLACE FUNCTION registrar_ingreso()
RETURNS TRIGGER AS $$
BEGIN
    -- Registrar ingreso
    INSERT INTO "IngresoProductos" ("Id_producto", "Cantidad", "Id_inventario")
    VALUES (NEW."Id_producto", NEW."Cantidad", NEW."Id");
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER after_update_inventario
AFTER UPDATE ON public."Inventario"
FOR EACH ROW
EXECUTE FUNCTION registrar_modificacion();

CREATE TRIGGER after_delete_inventario
AFTER DELETE ON public."Inventario"
FOR EACH ROW
EXECUTE FUNCTION registrar_modificacion();

CREATE TRIGGER after_insert_inventario
AFTER INSERT ON public."Inventario"
FOR EACH ROW
EXECUTE FUNCTION registrar_ingreso();




