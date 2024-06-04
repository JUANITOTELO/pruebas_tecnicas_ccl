using Microsoft.AspNetCore.Mvc;
using cclapi.Models;
using cclapi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;

namespace cclapi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ProductosController(AppDbContext context) : ControllerBase
    {
        private readonly AppDbContext _context = context;

        // GET: api/Productos
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Productos>>> GetProductos()
        {
            return await _context.Productos.ToListAsync();
        }
        // GET: api/Productos/id
        [HttpGet("{id}")]
        public async Task<ActionResult<Productos>> GetProductos(int id)
        {
            var productos = await _context.Productos.FindAsync(id);

            if (productos == null)
            {
                return NotFound();
            }

            return productos;
        }

        // POST: api/Productos
        [HttpPost]
        public async Task<ActionResult<Productos>> PostProductos(Productos productos)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL add_product({productos.Nombre}, {productos.Precio}, {productos.Descripcion})");

            return CreatedAtAction("GetProductos", new { id = productos.Id }, productos);
        }
        // PUT: api/Productos/id
        [HttpPut("{id}")]
        public async Task<IActionResult> PutProductos(int id, Productos productos)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_product({id}, {productos.Nombre}, {productos.Precio}, {productos.Descripcion})");

            return NoContent();
        }

        // PUT: api/Productos/precio/id
        [HttpPut("precio/{id}")]
        public async Task<IActionResult> PutProductosPrecio(int id, Productos productos)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_product_price({id}, {productos.Precio})");

            return NoContent();
        }

        // PUT: api/Productos/nombre/id
        [HttpPut("nombre/{id}")]
        public async Task<IActionResult> PutProductosNombre(int id, Productos productos)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_product_name({id}, {productos.Nombre})");

            return NoContent();
        }

        // DELETE: api/Productos/id
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteProductos(int id)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL delete_product({id})");

            return NoContent();
        }

    }
}