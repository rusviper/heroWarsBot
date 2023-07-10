local MainTools = {}


function MainTools:tableSize(t)
    size = 0
    for a,b in pairs(t) do
        --print("" .. a .. "-" .. tostring(b))
        size = size + 1
    end
    return size
end


return MainTools