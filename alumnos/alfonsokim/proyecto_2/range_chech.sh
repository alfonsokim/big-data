#/bin/bash

# Funcion que evalua el anio del nuevo registro y lo inserta en la tabla correspondiente
echo "CREATE OR REPLACE FUNCTION gedelt_check_range()"
echo "RETURNS TRIGGER AS \$\$"
echo "BEGIN"
ELS=""
for y in {1979..2015}
do
    echo "    ${ELS}IF ( NEW.Year >= $y AND NEW.Year < $((y+1)) ) THEN"
    echo "         INSERT INTO gdelt_y$y VALUES (NEW.*);"
    ELS="ELS"
done
# Si algun evento cae fuera del rango de fechas se inserta a la tabla padre
echo "    ELSE INSERT INTO gdelt_reduced VALUES (NEW.*);"
echo "    END IF;"
echo "RETURN NULL;"
echo "END;"
echo "\$\$"
echo "LANGUAGE plpgsql;"

echo ""
echo ""

# Trigger que captura el insert y llama a la funcion anterior
echo "CREATE TRIGGER insert_gedelt_trigger"
echo "    BEFORE INSERT ON gdelt_reduced"
echo "    FOR EACH ROW EXECUTE PROCEDURE gedelt_check_range();"
echo ""