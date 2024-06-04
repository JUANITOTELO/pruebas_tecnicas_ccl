--  Productos
CREATE OR REPLACE PROCEDURE add_product(
    p_nombre VARCHAR,
    p_precio NUMERIC(10,2),
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "Productos" ("Nombre", "Precio", "Descripcion")
    VALUES (p_nombre, p_precio, p_descripcion);
END;
$$;

CREATE OR REPLACE PROCEDURE update_product(
    p_id INT,
    p_nombre VARCHAR,
    p_precio NUMERIC,
    p_descripcion TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Productos"
    SET
        "Nombre" = p_nombre,
        "Precio" = p_precio,
        "Descripcion" = p_descripcion
    WHERE
        "Id" = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_product_price(
    p_id INTEGER,
    p_precio NUMERIC(10,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Productos"
    SET "Precio" = p_precio
    WHERE "Id" = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE update_product_name(
    p_id INTEGER,
    p_nombre VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Productos"
    SET "Nombre" = p_nombre
    WHERE "Id" = p_id;
END;
$$;

CREATE OR REPLACE FUNCTION delete_product(p_id integer)
RETURNS void AS $$
BEGIN
    -- Verificar si existen registros relacionados en IngresoProductos
    IF EXISTS (SELECT 1 FROM "IngresoProductos" WHERE "Id_inventario" = p_id) THEN
        RAISE EXCEPTION 'No se puede eliminar el producto porque existen registros relacionados en IngresoProductos';
    ELSE
        DELETE FROM "Inventario" WHERE "Id_producto" = p_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Usuarios
-- Procedure to add a new user
CREATE OR REPLACE PROCEDURE add_user(p_nombre VARCHAR, p_email VARCHAR, p_contraseña VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO "Usuarios" ("Nombre", "Email", "Contraseña")
    VALUES (p_nombre, p_email, p_contraseña);
END;
$$;

-- Procedure to update user name
CREATE OR REPLACE PROCEDURE update_user_name(p_id INTEGER, p_nombre VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Usuarios"
    SET "Nombre" = p_nombre
    WHERE "Id" = p_id;
END;
$$;

-- Procedure to update user email
CREATE OR REPLACE PROCEDURE update_user_email(p_id INTEGER, p_email VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Usuarios"
    SET "Email" = p_email
    WHERE "Id" = p_id;
END;
$$;

-- Procedure to update user password
CREATE OR REPLACE PROCEDURE update_user_password(p_id INTEGER, p_contraseña VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Usuarios"
    SET "Contraseña" = p_contraseña
    WHERE "Id" = p_id;
END;
$$;

-- Procedure to delete a user
CREATE OR REPLACE PROCEDURE delete_user(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM "Usuarios"
    WHERE "Id" = p_id;
END;
$$;

-- Inventario
CREATE OR REPLACE PROCEDURE add_inventory(
    p_id_producto INTEGER,
    p_cantidad INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if the product exists in the inventory
    IF EXISTS (SELECT 1 FROM "Inventario" WHERE "Id_producto" = p_id_producto) THEN
        -- If it exists, update the quantity
        UPDATE "Inventario"
        SET "Cantidad" = "Cantidad" + p_cantidad
        WHERE "Id_producto" = p_id_producto;
    ELSE
        -- If it does not exist, insert a new record
        INSERT INTO "Inventario" ("Id_producto", "Cantidad")
        VALUES (p_id_producto, p_cantidad);
    END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE public.delete_inventory(
    IN p_id_producto integer)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    -- Eliminar registros relacionados en IngresoProductos
    DELETE FROM "IngresoProductos"
    WHERE "Id_inventario" IN (
        SELECT "Id" FROM "Inventario" WHERE "Id_producto" = p_id_producto
    );

    -- Eliminar registros relacionados en SalidaProductos
    DELETE FROM "SalidaProductos"
    WHERE "Id_inventario" IN (
        SELECT "Id" FROM "Inventario" WHERE "Id_producto" = p_id_producto
    );

    -- Eliminar el registro en Inventario
    DELETE FROM "Inventario"
    WHERE "Id_producto" = p_id_producto;
END;
$BODY$;


CREATE OR REPLACE PROCEDURE update_inventory_quantity(
    p_id_producto INTEGER,
    p_cantidad INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE "Inventario"
    SET "Cantidad" = p_cantidad
    WHERE "Id_producto" = p_id_producto;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_inventory(
    p_id_producto INTEGER,
    p_cantidad INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if the product exists in the inventory
    IF EXISTS (SELECT 1 FROM "Inventario" WHERE "Id_producto" = p_id_producto) THEN
        -- Check if the quantity to be removed is available
        IF (SELECT "Cantidad" FROM "Inventario" WHERE "Id_producto" = p_id_producto) >= p_cantidad THEN
            -- If sufficient quantity is available, update the quantity
            UPDATE "Inventario"
            SET "Cantidad" = "Cantidad" - p_cantidad
            WHERE "Id_producto" = p_id_producto;
        ELSE
            -- If not enough quantity, raise an error
            RAISE EXCEPTION 'Not enough quantity in inventory for product ID %', p_id_producto;
        END IF;
    ELSE
        -- If the product does not exist in the inventory, raise an error
        RAISE EXCEPTION 'Product ID % does not exist in inventory', p_id_producto;
    END IF;
END;
$$;

