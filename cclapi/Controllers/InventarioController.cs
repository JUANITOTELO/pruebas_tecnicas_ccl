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
    public class InventarioController(AppDbContext context) : ControllerBase
    {
        private readonly AppDbContext _context = context;

        // GET: api/Inventario
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Inventario>>> GetInventario()
        {
            return await _context.Inventario.ToListAsync();
        }

        // POST: api/Inventario
        [HttpPost]
        public async Task<ActionResult<Inventario>> PostInventario(Inventario inventario)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL add_inventory({inventario.Id_producto}, {inventario.Cantidad})");
            return CreatedAtAction("GetInventario", new { id = inventario.Id }, inventario);
        }

        // PUT: api/Inventario/cantidad/id/cantidad
        [HttpPut("cantidad/{id_producto}/{cantidad}")]
        public async Task<IActionResult> PutInventarioCantidad(int id_producto, int cantidad)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_inventory_quantity({id_producto}, {cantidad})");
            return NoContent();
        }

        // DELETE: api/Inventario/cantidad/id/cantidad
        [HttpDelete("cantidad/{id}/{cantidad}")]
        public async Task<IActionResult> DeleteInventarioCantidad(int id, int cantidad)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL remove_inventory({id}, {cantidad})");
            return NoContent();
        }

        // DELETE: api/Inventario/id
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteInventario(int id)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL delete_inventory({id})");
            return NoContent();
        }
    }
}