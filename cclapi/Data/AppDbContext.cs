using cclapi.Models;
using Microsoft.EntityFrameworkCore;

namespace cclapi.Data{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }
        public DbSet<Productos> Productos { get; set; }
        public DbSet<Inventario> Inventario { get; set; }
        public DbSet<Usuarios> Usuarios { get; set; }
        public DbSet<IngresoProductos> IngresoProductos { get; set; }
        public DbSet<SalidaProductos> SalidaProductos { get; set; }
    }
}