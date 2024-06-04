namespace cclapi.Models
{
    public class SalidaProductos
    {
        public int Id { get; set; }
        public int Id_producto { get; set; }
        public int Cantidad { get; set; }
        public DateTime Fecha_salida { get; set; }
        public int Id_inventario { get; set; }
    }
}