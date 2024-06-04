namespace cclapi.Models
{
    public class IngresoProductos
    {
        public int Id { get; set; }
        public int Id_producto { get; set; }
        public int Cantidad { get; set; }
        public DateTime Fecha_ingreso { get; set; }
        public int Id_inventario { get; set; }
    }
}