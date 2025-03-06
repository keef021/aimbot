#include <iostream>
#include <SFML/Graphics.hpp>
#include <vector>
#include <string>

// Classe para gerenciar diferentes tipos de entrada (mouse e toque)
class InputManager {
private:
    bool isMobile;
    sf::Vector2i lastTouchPosition;
    bool touchActive;

public:
    InputManager() : isMobile(false), touchActive(false) {
        // Detectar automaticamente se está em ambiente mobile
        #ifdef __ANDROID__
            isMobile = true;
        #elif defined(__APPLE__) && TARGET_OS_IPHONE
            isMobile = true;
        #endif
    }

    void setMobileMode(bool mobile) {
        isMobile = mobile;
    }

    bool isMobileDevice() const {
        return isMobile;
    }

    void updateTouchPosition(int x, int y) {
        lastTouchPosition = sf::Vector2i(x, y);
        touchActive = true;
    }

    void endTouch() {
        touchActive = false;
    }

    sf::Vector2i getTouchPosition() const {
        return lastTouchPosition;
    }

    bool isTouchActive() const {
        return touchActive;
    }
};

class GameMenu {
private:
    sf::RenderWindow* window;
    sf::Font font;
    bool isMenuOpen;
    
    // Configurações
    bool aimbotEnabled;
    bool espEnabled;
    bool triggerBotEnabled;
    
    // Parâmetros do aimbot
    float aimbotSensitivity;
    float aimbotSmoothing;
    int aimbotTargetBone;
    float triggerBotDelay;
    
    // Elementos visuais
    sf::RectangleShape menuBackground;
    std::vector<sf::Text> menuOptions;
    std::vector<sf::RectangleShape> toggleButtons;
    std::vector<bool*> toggleValues;
    
    // Elementos para mobile
    sf::RectangleShape menuButton;
    sf::Text menuButtonText;
    std::vector<sf::RectangleShape> sliders;
    std::vector<sf::CircleShape> sliderHandles;
    std::vector<float*> sliderValues;
    std::vector<sf::Text> sliderTexts;
    std::vector<sf::Text> sliderValueTexts;

    // Gerenciador de entrada
    InputManager inputManager;
    
    // Estado de interação
    int activeSlider;
    
    void initializeMenu() {
        // Carregar fonte
        if (!font.loadFromFile("resources/fonts/arial.ttf")) {
            std::cerr << "Erro ao carregar fonte!" << std::endl;
        }
        
        // Configurar background do menu
        updateMenuSize();
        
        // Botão para abrir/fechar menu em dispositivos móveis
        initializeMenuButton();
        
        // Adicionar opções do menu
        addMenuOption("Aimbot", 70, &aimbotEnabled);
        addMenuOption("ESP", 130, &espEnabled);
        addMenuOption("Trigger Bot", 190, &triggerBotEnabled);
        
        // Adicionar sliders
        addSlider("Sensibilidade", 250, &aimbotSensitivity, 0.1f, 3.0f);
        addSlider("Suavização", 310, &aimbotSmoothing, 0.1f, 1.0f);
        addSlider("Delay Trigger", 370, &triggerBotDelay, 50.0f, 500.0f);
        
        activeSlider = -1;
    }
    
    void updateMenuSize() {
        // Dimensionar o menu com base no tamanho da janela
        sf::Vector2u windowSize = window->getSize();
        float menuWidth = inputManager.isMobileDevice() ? windowSize.x * 0.9f : 300.0f;
        float menuHeight = inputManager.isMobileDevice() ? windowSize.y * 0.8f : 450.0f;
        
        menuBackground.setSize(sf::Vector2f(menuWidth, menuHeight));
        menuBackground.setFillColor(sf::Color(30, 30, 30, 230));
        menuBackground.setOutlineThickness(2);
        menuBackground.setOutlineColor(sf::Color(0, 120, 215));
        
        // Centralizar menu na tela
        menuBackground.setPosition(
            (windowSize.x - menuWidth) / 2,
            (windowSize.y - menuHeight) / 2
        );
    }
    
    void initializeMenuButton() {
        sf::Vector2u windowSize = window->getSize();
        
        // Criar botão flutuante para abrir o menu
        menuButton.setSize(sf::Vector2f(60, 60));
        menuButton.setFillColor(sf::Color(0, 120, 215, 200));
        menuButton.setOutlineThickness(2);
        menuButton.setOutlineColor(sf::Color(255, 255, 255, 150));
        menuButton.setPosition(windowSize.x - 80, 20);
        
        // Texto do botão
        menuButtonText.setFont(font);
        menuButtonText.setString("Menu");
        menuButtonText.setCharacterSize(18);
        menuButtonText.setFillColor(sf::Color::White);
        
        // Centralizar o texto no botão
        sf::FloatRect textBounds = menuButtonText.getLocalBounds();
        menuButtonText.setPosition(
            menuButton.getPosition().x + (menuButton.getSize().x - textBounds.width) / 2,
            menuButton.getPosition().y + (menuButton.getSize().y - textBounds.height) / 2 - 5
        );
    }
    
    void addMenuOption(const std::string& name, float yPos, bool* toggleValue) {
        // Criar texto
        sf::Text text;
        text.setFont(font);
        text.setString(name);
        text.setCharacterSize(inputManager.isMobileDevice() ? 24 : 18);
        text.setFillColor(sf::Color::White);
        
        float xPos = menuBackground.getPosition().x + 20;
        text.setPosition(xPos, menuBackground.getPosition().y + yPos);
        menuOptions.push_back(text);
        
        // Criar botão toggle
        sf::RectangleShape toggle;
        float toggleWidth = inputManager.isMobileDevice() ? 60.0f : 40.0f;
        float toggleHeight = inputManager.isMobileDevice() ? 30.0f : 20.0f;
        toggle.setSize(sf::Vector2f(toggleWidth, toggleHeight));
        
        float toggleX = menuBackground.getPosition().x + menuBackground.getSize().x - toggleWidth - 20;
        toggle.setPosition(toggleX, menuBackground.getPosition().y + yPos);
        toggle.setOutlineThickness(1);
        toggle.setOutlineColor(sf::Color::White);
        
        if (*toggleValue) {
            toggle.setFillColor(sf::Color(0, 180, 0));
        } else {
            toggle.setFillColor(sf::Color(180, 0, 0));
        }
        
        toggleButtons.push_back(toggle);
        toggleValues.push_back(toggleValue);
    }
    
    void addSlider(const std::string& name, float yPos, float* sliderValue, float minValue, float maxValue) {
        // Texto do slider
        sf::Text text;
        text.setFont(font);
        text.setString(name);
        text.setCharacterSize(inputManager.isMobileDevice() ? 24 : 18);
        text.setFillColor(sf::Color::White);
        text.setPosition(menuBackground.getPosition().x + 20, menuBackground.getPosition().y + yPos);
        sliderTexts.push_back(text);
        
        // Valor numérico do slider
        sf::Text valueText;
        valueText.setFont(font);
        valueText.setString(std::to_string(*sliderValue));
        valueText.setCharacterSize(inputManager.isMobileDevice() ? 20 : 16);
        valueText.setFillColor(sf::Color::Yellow);
        valueText.setPosition(menuBackground.getPosition().x + 20, menuBackground.getPosition().y + yPos + 25);
        sliderValueTexts.push_back(valueText);
        
        // Trilha do slider
        sf::RectangleShape slider;
        float sliderWidth = menuBackground.getSize().x - 40;
        float sliderHeight = inputManager.isMobileDevice() ? 10.0f : 5.0f;
        slider.setSize(sf::Vector2f(sliderWidth, sliderHeight));
        slider.setPosition(menuBackground.getPosition().x + 20, menuBackground.getPosition().y + yPos + 50);
        slider.setFillColor(sf::Color(80, 80, 80));
        slider.setOutlineThickness(1);
        slider.setOutlineColor(sf::Color(150, 150, 150));
        sliders.push_back(slider);
        
        // Handle do slider
        sf::CircleShape handle;
        float handleRadius = inputManager.isMobileDevice() ? 15.0f : 8.0f;
        handle.setRadius(handleRadius);
        handle.setFillColor(sf::Color(0, 120, 215));
        handle.setOutlineThickness(2);
        handle.setOutlineColor(sf::Color::White);
        
        // Calcular posição com base no valor atual
        float valuePercent = (*sliderValue - minValue) / (maxValue - minValue);
        float handleX = slider.getPosition().x + valuePercent * sliderWidth;
        handle.setPosition(handleX - handleRadius, slider.getPosition().y + sliderHeight/2 - handleRadius);
        sliderHandles.push_back(handle);
        
        // Armazenar referência para o valor
        sliderValues.push_back(sliderValue);
    }
    
    void updateSliderPosition(int index) {
        if (index < 0 || index >= static_cast<int>(sliders.size())) return;
        
        // Atualizar valor com base na posição do mouse/toque
        sf::Vector2i mousePos;
        if (inputManager.isTouchActive()) {
            mousePos = inputManager.getTouchPosition();
        } else {
            mousePos = sf::Mouse::getPosition(*window);
        }
        
        float minValue = 0.0f;
        float maxValue = 1.0f;
        
        // Definir valores mínimos e máximos com base no índice
        if (index == 0) { // Sensibilidade
            minValue = 0.1f;
            maxValue = 3.0f;
        } else if (index == 1) { // Suavização
            minValue = 0.1f;
            maxValue = 1.0f;
        } else if (index == 2) { // Delay Trigger
            minValue = 50.0f;
            maxValue = 500.0f;
        }
        
        sf::RectangleShape& slider = sliders[index];
        sf::CircleShape& handle = sliderHandles[index];
        float handleRadius = handle.getRadius();
        
        // Limitar movimento dentro do slider
        float x = mousePos.x;
        if (x < slider.getPosition().x) x = slider.getPosition().x;
        if (x > slider.getPosition().x + slider.getSize().x) x = slider.getPosition().x + slider.getSize().x;
        
        // Atualizar posição do handle
        handle.setPosition(x - handleRadius, handle.getPosition().y);
        
        // Atualizar valor com base na posição
        float percent = (x - slider.getPosition().x) / slider.getSize().x;
        *sliderValues[index] = minValue + percent * (maxValue - minValue);
        
        // Formatar o texto do valor
        std::string valueStr;
        if (index == 2) { // Delay é um valor inteiro
            valueStr = std::to_string(static_cast<int>(*sliderValues[index]));
        } else {
            // Formatar com 2 casas decimais
            char buffer[32];
            std::sprintf(buffer, "%.2f", *sliderValues[index]);
            valueStr = buffer;
        }
        
        // Atualizar texto do valor
        sliderValueTexts[index].setString(valueStr);
    }

public:
    GameMenu(sf::RenderWindow* gameWindow) : window(gameWindow), isMenuOpen(false), 
        aimbotEnabled(false), espEnabled(false), triggerBotEnabled(false),
        aimbotSensitivity(1.0f), aimbotSmoothing(0.5f), aimbotTargetBone(0),
        triggerBotDelay(100.0f), activeSlider(-1) {
        initializeMenu();
    }
    
    void toggleMenu() {
        isMenuOpen = !isMenuOpen;
    }
    
    bool isOpen() const {
        return isMenuOpen;
    }
    
    void handleResize() {
        // Atualizar posições e tamanhos quando a janela for redimensionada
        updateMenuSize();
        initializeMenuButton();
        
        // Reposicionar todos os elementos
        for (size_t i = 0; i < menuOptions.size(); i++) {
            float yPos = 70.0f + i * 60.0f;
            
            menuOptions[i].setPosition(
                menuBackground.getPosition().x + 20, 
                menuBackground.getPosition().y + yPos
            );
            
            float toggleWidth = inputManager.isMobileDevice() ? 60.0f : 40.0f;
            float toggleX = menuBackground.getPosition().x + menuBackground.getSize().x - toggleWidth - 20;
            
            toggleButtons[i].setSize(sf::Vector2f(
                toggleWidth, 
                inputManager.isMobileDevice() ? 30.0f : 20.0f
            ));
            
            toggleButtons[i].setPosition(
                toggleX,
                menuBackground.getPosition().y + yPos
            );
        }
        
        // Atualizar posição dos sliders
        for (size_t i = 0; i < sliders.size(); i++) {
            float yPos = 250.0f + i * 60.0f;
            
            sliderTexts[i].setPosition(
                menuBackground.getPosition().x + 20,
                menuBackground.getPosition().y + yPos
            );
            
            sliderValueTexts[i].setPosition(
                menuBackground.getPosition().x + 20,
                menuBackground.getPosition().y + yPos + 25
            );
            
            float sliderWidth = menuBackground.getSize().x - 40;
            sliders[i].setSize(sf::Vector2f(
                sliderWidth,
                inputManager.isMobileDevice() ? 10.0f : 5.0f
            ));
            
            sliders[i].setPosition(
                menuBackground.getPosition().x + 20,
                menuBackground.getPosition().y + yPos + 50
            );
            
            // Recalcular posição do handle
            float handleRadius = sliderHandles[i].getRadius();
            float minValue = (i == 0) ? 0.1f : (i == 1 ? 0.1f : 50.0f);
            float maxValue = (i == 0) ? 3.0f : (i == 1 ? 1.0f : 500.0f);
            
            float valuePercent = (*sliderValues[i] - minValue) / (maxValue - minValue);
            float handleX = sliders[i].getPosition().x + valuePercent * sliderWidth;
            
            sliderHandles[i].setPosition(
                handleX - handleRadius,
                sliders[i].getPosition().y + sliders[i].getSize().y/2 - handleRadius
            );
        }
    }
    
    void handleTouchBegin(int x, int y) {
        inputManager.updateTouchPosition(x, y);
        handleInput(x, y, true);
    }
    
    void handleTouchMove(int x, int y) {
        inputManager.updateTouchPosition(x, y);
        
        // Se um slider estiver ativo, atualizar sua posição
        if (activeSlider != -1) {
            updateSliderPosition(activeSlider);
        }
    }
    
    void handleTouchEnd() {
        inputManager.endTouch();
        activeSlider = -1;
    }
    
    void handleMouseClick(int x, int y) {
        handleInput(x, y, false);
    }
    
    void handleMouseMove(int x, int y) {
        if (activeSlider != -1 && sf::Mouse::isButtonPressed(sf::Mouse::Left)) {
            updateSliderPosition(activeSlider);
        }
    }
    
    void handleMouseRelease() {
        activeSlider = -1;
    }
    
    void handleInput(int x, int y, bool isTouchEvent) {
        // Verificar clique/toque no botão de menu
        if (menuButton.getGlobalBounds().contains(x, y)) {
            toggleMenu();
            return;
        }
        
        if (!isMenuOpen) return;
        
        // Verificar cliques nos toggles
        for (size_t i = 0; i < toggleButtons.size(); i++) {
            if (toggleButtons[i].getGlobalBounds().contains(x, y)) {
                *toggleValues[i] = !(*toggleValues[i]);
                
                if (*toggleValues[i]) {
                    toggleButtons[i].setFillColor(sf::Color(0, 180, 0));
                } else {
                    toggleButtons[i].setFillColor(sf::Color(180, 0, 0));
                }
                
                std::cout << menuOptions[i].getString().toAnsiString() << " " 
                          << (*toggleValues[i] ? "ativado" : "desativado") << std::endl;
                
                return;
            }
        }
        
        // Verificar cliques nos sliders
        for (size_t i = 0; i < sliderHandles.size(); i++) {
            // Verificar se o clique/toque foi no handle ou na trilha
            if (sliderHandles[i].getGlobalBounds().contains(x, y) || 
                sliders[i].getGlobalBounds().contains(x, y)) {
                activeSlider = i;
                updateSliderPosition(i);
                return;
            }
        }
    }
    
    void draw() {
        // Sempre desenhar o botão de menu em dispositivos móveis
        if (inputManager.isMobileDevice()) {
            window->draw(menuButton);
            window->draw(menuButtonText);
        }
        
        if (!isMenuOpen) return;
        
        window->draw(menuBackground);
        
        // Desenhar toggles e textos
        for (const auto& option : menuOptions) {
            window->draw(option);
        }
        
        for (const auto& toggle : toggleButtons) {
            window->draw(toggle);
        }
        
        // Desenhar sliders
        for (const auto& sliderText : sliderTexts) {
            window->draw(sliderText);
        }
        
        for (const auto& valueText : sliderValueTexts) {
            window->draw(valueText);
        }
        
        for (const auto& slider : sliders) {
            window->draw(slider);
        }
        
        for (const auto& handle : sliderHandles) {
            window->draw(handle);
        }
    }
    
    // Métodos para configurar o modo mobile explicitamente
    void setMobileMode(bool mobile) {
        inputManager.setMobileMode(mobile);
        handleResize(); // Atualiza a interface
    }
    
    bool isMobileMode() const {
        return inputManager.isMobileDevice();
    }
    
    // Getters para configurações
    bool isAimbotEnabled() const { return aimbotEnabled; }
    bool isESPEnabled() const { return espEnabled; }
    bool isTriggerBotEnabled() const { return triggerBotEnabled; }
    float getAimbotSensitivity() const { return aimbotSensitivity; }
    float getAimbotSmoothing() const { return aimbotSmoothing; }
    int getAimbotTargetBone() const { return aimbotTargetBone; }
    float getTriggerBotDelay() const { return triggerBotDelay; }
};

// Função principal atualizada para demonstração com suporte mobile
int main() {
    // Criar janela
    sf::RenderWindow window(sf::VideoMode(800, 600), "Game Menu Demo");
    window.setFramerateLimit(60);
    
    // Inicializar menu
    GameMenu menu(&window);
    
    // Habilitar modo mobile para testes se necessário
    // menu.setMobileMode(true);
    
    // Inicializar objetos de jogo
    Aimbot aimbot;
    TriggerBot triggerBot;
    
    // Criar jogador local e entidades
    Player localPlayer;
    std::vector<Entity> players;
    
    // Loop principal
    while (window.isOpen()) {
        sf::Event event;
        while (window.pollEvent(event)) {
            if (event.type == sf::Event::Closed) {
                window.close();
            }
            
            // Tratamento de redimensionamento da janela
            if (event.type == sf::Event::Resized) {
                sf::FloatRect visibleArea(0, 0, event.size.width, event.size.height);
                window.setView(sf::View(visibleArea));
                menu.handleResize();
            }
            
            // Tratamento de eventos de toque para dispositivos móveis
            if (event.type == sf::Event::TouchBegan) {
                menu.handleTouchBegin(event.touch.x, event.touch.y);
            }
            
            if (event.type == sf::Event::TouchMoved) {
                menu.handleTouchMove(event.touch.x, event.touch.y);
            }
            
            if (event.type == sf::Event::TouchEnded) {
                menu.handleTouchEnd();
            }
            
            // Tratamento de mouse para desktop
            if (event.type == sf::Event::MouseButtonPressed) {
                if (event.mouseButton.button == sf::Mouse::Right && !menu.isMobileMode()) {
                    menu.toggleMenu();
                } else if (event.mouseButton.button == sf::Mouse::Left) {
                    menu.handleMouseClick(event.mouseButton.x, event.mouseButton.y);
                }
            }
            
            if (event.type == sf::Event::MouseMoved) {
                menu.handleMouseMove(event.mouseMove.x, event.mouseMove.y);
            }
            
            if (event.type == sf::Event::MouseButtonReleased) {
                if (event.mouseButton.button == sf::Mouse::Left) {
                    menu.handleMouseRelease();
                }
            }
        }
        
        // Atualizar lógica do jogo
        if (menu.isAimbotEnabled()) {
            aimbot.setSensitivity(menu.getAimbotSensitivity());
            aimbot.setSmoothing(menu.getAimbotSmoothing());
            aimbot.setTargetBone(menu.getAimbotTargetBone());
            aimbot.update(players, localPlayer);
        }
        
        if (menu.isTriggerBotEnabled()) {
            triggerBot.setDelay(menu.getTriggerBotDelay());
            triggerBot.update(players, localPlayer);
        }
        
        // Renderizar
        window.clear(sf::Color(50, 50, 50));
        
        // Renderizar ESP se ativado
        if (menu.isESPEnabled()) {
            // Código para renderizar ESP (wallhack visual)
        }
        
        // Renderizar jogo
        // ...
        
        // Renderizar menu por último (para estar sobre tudo)
        menu.draw();
        
        window.display();
    }
    
    return 0;
}
