const std = @import("std");

const Hechizo = struct {
    nombre:   []const u8,
    poder:    u32,
    elemento: []const u8,
};

const hechizos_base = [_]Hechizo{
    .{ .nombre = "Bola de Fuego",    .poder = 80, .elemento = "fuego" },
    .{ .nombre = "Rayo Helado",      .poder = 70, .elemento = "hielo" },
    .{ .nombre = "Tormenta Arcana",  .poder = 95, .elemento = "rayo"  },
    .{ .nombre = "Flecha de Viento", .poder = 60, .elemento = "aire"  },
};

pub fn main() !void {
    // Arena allocator: todas las allocaciones se liberan juntas al final
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    std.debug.print("=== La Llave de Memoria — Arena Allocator ===\n\n", .{});

    // Copiar el array estático al arena (allocación dinámica)
    const hechizos = try alloc.dupe(Hechizo, &hechizos_base);

    std.debug.print("Hechizos en el arena:\n", .{});
    for (hechizos) |h| {
        std.debug.print("  {s}  poder={d}  elemento={s}\n", .{ h.nombre, h.poder, h.elemento });
    }

    // Allocar strings con formato dinámico dentro del arena
    const prefijos = [_][]const u8{ "Mega", "Ultra", "Hiper", "Sobre" };
    std.debug.print("\nNombres potenciados (strings allocados en el arena):\n", .{});
    for (hechizos, 0..) |h, i| {
        const potenciado = try std.fmt.allocPrint(alloc, "{s} {s}", .{ prefijos[i], h.nombre });
        std.debug.print("  » {s}\n", .{potenciado});
    }

    // El `defer arena.deinit()` de arriba libera todo cuando main() termina
    std.debug.print("\nArena liberada automáticamente al salir de main().\n", .{});
}
