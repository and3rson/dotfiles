function getline(filename)
    local file = io.open(filename)
    local line = file:read()
    file:close()
    return line
end

return {
    getline=getline
}
