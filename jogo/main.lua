LARGURA_TELA = 320
ALTURA_TELA = 480
MAX_METEOROS = 12
METEOROS_ATINGIDOS = 0
NUMERO_METEOROS_OBJETIVO = 100

aviao = {
    src = "imagens/14bis.png",
    a = 64,
    l = 56,
    x = LARGURA_TELA/2 - 56 / 2,
    y = ALTURA_TELA - 64 / 2,
    tiros = {}
}

meteoros = {}

function darTiro()
    table.insert(aviao.tiros, {
        x = aviao.x + aviao.l / 2,
        y = aviao.y,
        l = 16,
        a = 16,
    })
    disparo:play()
end

function moveTiros()
    for i = #aviao.tiros, 1, -1 do
        if aviao.tiros[i].y > 0 then
            aviao.tiros[i].y = aviao.tiros[i].y - 2
        else
            table.remove(aviao.tiros, i)
        end
    end
end

function destroiAviao()
    aviao.src = "imagens/explosao_nave.png"
    aviao.imagem = love.graphics.newImage(aviao.src)
    aviao.l = 67
    aviao.a = 67

    destruicao:play()
end

function temColisao(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return
        X2 < X1 + L1 and
        X1 < X2 + L2 and
        Y1 < Y2 + A2 and
        Y2 < Y1 + A1
end

function removeMeteoros()
    for i = #meteoros, 1, -1 do
        if
            meteoros[i].y > ALTURA_TELA
            or meteoros[i].x > LARGURA_TELA
            or meteoros[i].x < -70
        then
            table.remove(meteoros, i)
        end
    end
end

function criarMeteoro()
    table.insert(meteoros, {
        x = math.random(LARGURA_TELA),
        y = -70,
        a = 44,
        l = 50,
        peso = math.random(3) / 6,
        deslocamento_horizontal = math.random(-1, 1) / 6
    })
end

function move14bis()
    if love.keyboard.isDown('w') then
        aviao.y = aviao.y - 1
    end

    if love.keyboard.isDown('s') then
        aviao.y = aviao.y + 1
    end

    if love.keyboard.isDown('a') then
        aviao.x = aviao.x - 1
    end

    if love.keyboard.isDown('d') then
        aviao.x = aviao.x + 1
    end
end

function trocaMusicaDeFundo()
    musica:stop()
    game_over:play()
end

function checaColisaoComAviao()
    for k, m in pairs(meteoros) do
        if (
            temColisao(
                m.x, m.y, m.l, m.a,
                aviao.x, aviao.y, aviao.l, aviao.a
            )
        ) then
            trocaMusicaDeFundo()
            destroiAviao()
            FIM_JOGO = true
        end
    end
end

function checaColisaoComTiros()
    for i = #aviao.tiros, 1, -1 do
        for j = #meteoros, 1, -1 do
            local t = aviao.tiros[i]
            local m = meteoros[j]

            if (
                temColisao(
                    t.x, t.y, t.l, t.a,
                    m.x, m.y, m.l, m.a
                )
            ) then
                METEOROS_ATINGIDOS = METEOROS_ATINGIDOS + 1
                table.remove(aviao.tiros, i)
                table.remove(meteoros, j)
                break
            end
        end
    end
end

function checaColisoes()
    checaColisaoComAviao()
    checaColisaoComTiros()
end

function checaObjetivoConcluido()
    if METEOROS_ATINGIDOS >= NUMERO_METEOROS_OBJETIVO then
        VENCEDOR = true
        musica:stop()
        winner:play()
    end
end

function moveMeteoros()
    for k, m in pairs(meteoros) do
        m.y = m.y + m.peso
        m.x = m.x + m.deslocamento_horizontal
    end
end

function love.load()
    love.window.setMode(LARGURA_TELA, ALTURA_TELA, { resizable = false })
    love.window.setTitle("14bis vs Meteoros")

    math.randomseed(os.time())

    background = love.graphics.newImage("imagens/background.png")
    aviao.imagem = love.graphics.newImage(aviao.src)

    meteoro_img = love.graphics.newImage("imagens/meteoro.png")
    tiro_img = love.graphics.newImage("imagens/tiro.png")
    gameover_img = love.graphics.newImage("imagens/gameover.png")
    vencedor_img = love.graphics.newImage("imagens/vencedor.png")

    musica = love.audio.newSource("audios/ambiente.wav", "static")
    musica:setLooping(true)
    musica:play()

    destruicao = love.audio.newSource("audios/destruicao.wav", "static")
    game_over = love.audio.newSource("audios/game_over.wav", "static")
    disparo = love.audio.newSource("audios/disparo.wav", "static")
    winner = love.audio.newSource("audios/winner.wav", "static")
end

function love.update(dt)
    if FIM_JOGO or VENCEDOR then
        return
    end

    if love.keyboard.isDown('w', 'a', 's', 'd') then
        move14bis()
    end

    removeMeteoros()

    if #meteoros < MAX_METEOROS then
        criarMeteoro()
    end

    moveMeteoros()
    moveTiros()
    checaColisoes()
    checaObjetivoConcluido()
end

function love.keypressed(tecla)
    if FIM_JOGO or VENCEDOR then
        return
    end

    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        darTiro()
    end
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(aviao.imagem, aviao.x, aviao.y)

    for k, m in pairs(meteoros) do
        love.graphics.draw(meteoro_img, m.x, m.y)
    end

    for k, t in pairs(aviao.tiros) do
        love.graphics.draw(tiro_img, t.x, t.y)
    end

    love.graphics.print(
        "Meteoros restantes "..NUMERO_METEOROS_OBJETIVO - METEOROS_ATINGIDOS, 0, 0
    )

    if FIM_JOGO then
        love.graphics.draw(
            gameover_img,
            LARGURA_TELA / 2 - gameover_img:getWidth() / 2,
            ALTURA_TELA / 2 - gameover_img:getHeight() / 2
        )
    end

    if VENCEDOR then
        love.graphics.draw(
            vencedor_img,
            LARGURA_TELA / 2 - vencedor_img:getWidth() / 2,
            ALTURA_TELA / 2 - vencedor_img:getHeight() / 2
        )
    end
end