*** Settings ***
Library             Selenium2Library
# Library             RequestsLibrary

*** Variables ***
# defaultní nastavení, může být přepsáno v jednotlivých resource souborech nebo z konzole `> pybot -v "BROWSER:firefox" ...`
${SERVER}
${BROWSER}          chrome
${SDELAY}           0   # sekund, např: 0.2

*** Keywords ***
Open Browser To
    [Documentation]  Otevře prohlížeč na zadanou adresu.
    [Arguments]      ${url}
    # [Arguments]      ${url}    ${title}
    Open Browser     ${url}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed         ${SDELAY}
    # Title Should Be  ${title}
    Inject jQuery

Inject jQuery
    [Documentation]  Pokud již není JQuery nadefinováno, vloží jej a poté počká
    ${jQuery injected}    Execute Javascript  return (typeof(jQuery) != "undefined") ? false : (function(){var script = document.createElement('script');script.src = 'http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js';document.head.appendChild(script);return true})()
    Run Keyword Unless  ${jQuery injected}  Log    jQuery already present.
    Run Keyword If      ${jQuery injected}  Log    Injecting jQuery...
    Run Keyword If      ${jQuery injected}  Sleep  2000ms

Get Text
    [Documentation]  Vrátí text uvnitř elementu.
    [Arguments]     ${locator}
    ${text}         Execute Javascript  return $(${locator}).text()
    [return]        ${text}

Get List Length
    [Documentation]  Vrátí počet prvků listu nebo selectu.
    [Arguments]     ${locator}
    @{items}        Get List items      ${locator}
    ${length}       Get Length          ${items}
    [return]        ${length}

Get Random Integer
    [Arguments]     ${min}  ${max}
    ${value}        Evaluate            random.randint(${min}, ${max})    random,sys
    [return]        ${value}

Get Matching Count
    [Documentation]  Vrátí počet elementů, které vyhovují zadanému jQuery selectoru.
    [Arguments]     ${locator}
    ${length}       Execute Javascript  return $('${locator}'.replace('jquery=','')).length
    [return]        ${length}

Get Element Width
    [Documentation]  Vrátí šířku elementu dle zadaného jQuery selectoru.
    [Arguments]     ${locator}
    ${width}        Execute Javascript  return $('${locator}'.replace('jquery=','')).width()
    [return]        ${width}

Should Match Element
    [Documentation]  Ověří, zdali element dle zadaného jQuery selectoru existuje.
    [Arguments]     ${locator}  ${msg}=Element neexistuje
    ${exists}       Execute Javascript  return !!$('${locator}'.replace('jquery=',''))[0]
    Should Be True  ${exists} == 1  ${msg} : ${locator}

Should Not Match Element
    [Documentation]  Ověří, zdali element dle zadaného jQuery selectoru ne-existuje.
    [Arguments]     ${locator}  ${msg}=Element by neměl existovat
    ${exists}       Execute Javascript  return !!$('${locator}'.replace('jquery=',''))[0]
    Should Be True  ${exists} == 0  ${msg} : ${locator}

# Wait Until Page Contains Element ??
# Wait Until Page Does Not Contain
#     [Documentation]  Počká než kolekce elementů přestane existovat.
#     [Arguments]     ${locator}  ${timeout}=60s
#     Wait For Condition  return $('${locator}').length == 0    timeout=${timeout}  #syntax jako Execute Javascript. Ověřuje true | false