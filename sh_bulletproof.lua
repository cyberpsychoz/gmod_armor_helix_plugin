ITEM.name = "Бронежилет"
ITEM.description = "Защищает от пуль и осколков."
ITEM.model = "models/props_c17/SuitCase_Passenger_Physics.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.category = "Броня"
ITEM.outfitCategory = "torso"
ITEM.pacData = {} -- Здесь можно добавить PAC3 части для изменения внешнего вида
ITEM.armor = 50 -- Уровень защиты от 0 до 100

-- Добавим функцию, которая будет вызываться при получении урона игроком с надетой броней
function ITEM:OnTakeDamage(client, dmgInfo)
    -- Проверим, что урон был нанесен оружием
    local attacker = dmgInfo:GetAttacker()
    if (IsValid(attacker) and attacker:IsPlayer()) then
        local weapon = attacker:GetActiveWeapon()
        if (IsValid(weapon) and weapon:IsWeapon()) then
            -- Получим базовое значение урона
            local damage = dmgInfo:GetDamage()
            -- Вычислим коэффициент снижения урона в зависимости от уровня защиты брони
            local reduction = 1 - (self.armor / 100)
            -- Умножим урон на коэффициент снижения
            local newDamage = damage * reduction
            -- Установим новое значение урона
            dmgInfo:SetDamage(newDamage)
        end
    end
end

-- Добавим хук, который будет вызывать функцию OnTakeDamage
function PLUGIN:EntityTakeDamage(client, dmgInfo)
    -- Проверим, что сущность - это игрок с загруженным персонажем
    if (client:IsPlayer() and client:GetCharacter()) then
        -- Получим инвентарь игрока
        local inventory = client:GetCharacter():GetInventory()
        -- Переберем все предметы в инвентаре
        for _, item in pairs(inventory:GetItems()) do
            -- Проверим, что предмет - это броня и он экипирован
            if (item.base == "base_armor" and item:GetData("equip")) then
                -- Вызовем функцию OnTakeDamage для этого предмета
                item:OnTakeDamage(client, dmgInfo)
            end
        end
    end
end
