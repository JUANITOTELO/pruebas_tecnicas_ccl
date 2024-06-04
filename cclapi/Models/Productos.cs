namespace cclapi.Models
{
    public class Productos(int Id, string Nombre, string Descripcion, decimal Precio)
    {
        public int Id { get; set; } = Id;
        public required string Nombre { get; set; } = Nombre;
        public string Descripcion { get; set; } = Descripcion;
        public required decimal Precio { get; set; } = Precio;
    }
}