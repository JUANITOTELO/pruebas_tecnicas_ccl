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
    public class EntradasController(AppDbContext context) : ControllerBase
    {
        private readonly AppDbContext _context = context;

        // GET: api/Entradas
        [HttpGet]
        public async Task<ActionResult<IEnumerable<IngresoProductos>>> GetIngresoProducto()
        {
            return await _context.IngresoProductos.ToListAsync();
        }
    }
}