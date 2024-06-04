namespace cclapi.Models
{
    public class Usuarios(int Id, string Nombre, string Email, string Contraseña)
    {
        public int Id { get; set; } = Id;
        public required string Nombre { get; set; } = Nombre;
        public required string Email { get; set; } = Email;
        public required string Contraseña { get; set; } = Contraseña;
    }
}