# Instalacja pluginu Rojo w Roblox Studio

## Metoda 1: Przez Roblox Studio (Zalecana)

1. **Otwórz Roblox Studio**
2. **Przejdź do View → Plugins**
3. **Kliknij "Manage Plugins"**
4. **Wyszukaj "Rojo"**
5. **Znajdź plugin "Rojo" (autor: Roblox)**
6. **Kliknij "Get Plugin"**
7. **Zatwierdź instalację**

## Metoda 2: Przez stronę Roblox

1. **Przejdź na stronę**: https://www.roblox.com/library/5993166417/Rojo
2. **Kliknij "Get Plugin"**
3. **Otwórz Roblox Studio**
4. **Plugin powinien być automatycznie zainstalowany**

## Weryfikacja instalacji

1. **W Roblox Studio, przejdź do View → Plugins**
2. **Sprawdź czy plugin "Rojo" jest widoczny na liście**
3. **Jeśli tak, kliknij na niego aby go uruchomić**

## Pierwsze uruchomienie

1. **Uruchom plugin Rojo w Roblox Studio**
2. **Kliknij "Connect"**
3. **Wprowadź adres serwera**: `http://localhost:34872`
4. **Kliknij "Connect"**

## Rozwiązywanie problemów z instalacją

### Problem: Plugin nie pojawia się w wyszukiwaniu
- Spróbuj wyszukać "Rojo" w różnych wariantach
- Sprawdź czy masz najnowszą wersję Roblox Studio
- Spróbuj przejść bezpośrednio przez link: https://www.roblox.com/library/5993166417/Rojo

### Problem: Plugin nie instaluje się
- Sprawdź czy masz uprawnienia administratora
- Spróbuj uruchomić Roblox Studio jako administrator
- Sprawdź czy antywirus nie blokuje instalacji

### Problem: Plugin nie łączy się z serwerem
- Upewnij się, że serwer Rojo jest uruchomiony (`start_rojo.bat`)
- Sprawdź czy port 34872 nie jest zajęty
- Sprawdź czy firewall nie blokuje połączenia

## Alternatywne porty

Jeśli port 34872 jest zajęty, możesz zmienić port w pliku `start_rojo.bat`:

```batch
aftman run -- rojo serve --port 34873
```

I odpowiednio zmienić adres w pluginie na: `http://localhost:34873`
