-- luacheck: globals screen

local find_by_name = function(name)
    for i = 1, screen.count() do
        for _, other in pairs(screen[i].tags) do
            if other.name == name then
                return other
            end
        end
    end
end

return {
    find_by_name=find_by_name
}
