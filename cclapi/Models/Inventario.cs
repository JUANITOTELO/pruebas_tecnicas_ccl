namespace cclapi.Models
{
    public class Inventario(int Id, int Id_producto, int Cantidad)
    {
        public int Id { get; set; } = Id;
        public required int Id_producto { get; set; } = Id_producto;
        public required int Cantidad { get; set; } = Cantidad;
        public DateTime Last_updated { get; set; } = DateTime.Now;
    }
}