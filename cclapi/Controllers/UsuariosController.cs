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
    public class UsuariosController(AppDbContext context) : ControllerBase
    {
        private readonly AppDbContext _context = context;

        // GET: api/Usuarios
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Usuarios>>> GetUsuarios()
        {
            return await _context.Usuarios.ToListAsync();
        }

        // GET: api/Usuarios/id
        [HttpGet("{id}")]
        public async Task<ActionResult<Usuarios>> GetUsuarios(int id)
        {
            var usuarios = await _context.Usuarios.FindAsync(id);

            if (usuarios == null)
            {
                return NotFound();
            }

            return usuarios;
        }

        // POST: api/Usuarios
        [HttpPost]
        public async Task<ActionResult<Usuarios>> PostUsuarios(Usuarios usuarios)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL add_user({usuarios.Nombre}, {usuarios.Email}, {usuarios.Contraseña})");

            return CreatedAtAction("GetUsuarios", new { id = usuarios.Id }, usuarios);
        }

        // PUT: api/Usuarios/nombre/id
        [HttpPut("nombre/{id}")]
        public async Task<IActionResult> PutUsuariosNombre(int id, Usuarios usuarios)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_user_name({id}, {usuarios.Nombre})");

            return NoContent();
        }

        // PUT: api/Usuarios/email/id
        [HttpPut("email/{id}")]
        public async Task<IActionResult> PutUsuariosEmail(int id, Usuarios usuarios)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_user_email({id}, {usuarios.Email})");

            return NoContent();
        }

        // PUT: api/Usuarios/contraseña/id
        [HttpPut("contraseña/{id}")]
        public async Task<IActionResult> PutUsuariosContraseña(int id, Usuarios usuarios)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL update_user_password({id}, {usuarios.Contraseña})");

            return NoContent();
        }

        // DELETE: api/Usuarios/id
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUsuarios(int id)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"CALL delete_user({id})");

            return NoContent();
        }
    }
}