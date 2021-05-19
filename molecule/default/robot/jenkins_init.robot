*** Settings ***
Documentation   Jenkins Init
Library         SeleniumLibrary         timeout=600
Library         OperatingSystem
*** Variables ***
${INIT_URL}                 http://localhost:8080
${BROWSER}                  headlessfirefox
${input_SECRETS}            xpath=//input[@class='form-control']
# ${SECRETS}                  Get File        /tmp/inti_passowrd.txt
${button}                   xpath=//input[@value='Continue']
${install_suggested}        xpath=//*[@id="main-panel"]/div/div/div/div/div/div[2]/div/p[2]/a[1]

${createadmin_iframe}       //*[@id="setup-first-user"]
${input_USERNAME}           xpath=//*[@id="create-admin-user"]/form/div[1]/table/tbody/tr[1]/td[2]/input
${input_PASSWORD1}          xpath=//*[@id="create-admin-user"]/form/div[1]/table/tbody/tr[2]/td[2]/input
${input_PASSWORD2}          xpath=//*[@id="create-admin-user"]/form/div[1]/table/tbody/tr[3]/td[2]/input
${input_FULL_NAME}          xpath=//*[@id="create-admin-user"]/form/div[1]/table/tbody/tr[4]/td[2]/input
${input_EMAIL}              xpath=//*[@id="create-admin-user"]/form/div[1]/table/tbody/tr[5]/td[2]/input
${USERNAME}                 admin
${PASSWORD}                 password
${FULL_NAME}                adminjar
${EMAIL}                    admin@gmail.com
${firstAdminCreate}         //*[@id="create-admin-user"]/form/h1

${saveandcontinue}          //*[@id="main-panel"]/div/div/div/div/div/div[3]/button[2]
${saveandfinish}            //*[@id="main-panel"]/div/div/div/div/div/div[3]/button[2]
${installdone}              //*[@id="main-panel"]/div/div/div/div/div/div[2]/div/button
${configuration_iframe}     
${input_Jenkins_URL}        //*[@id="root-url"]
${Jenkins_URL}
${DELAY}    2
*** Keywords ***
Set Chrome Options
    [Documentation]        Set Chrome options for headless mode
    ${chrome_options} =    Evaluate    selenium.webdriver.ChromeOptions()
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    [Return]               ${chrome_options}

Open Headless Chrome Browser to Page
    [Arguments]            ${URL}
    ${chrome_options}=     Set Chrome Options
    Create Webdriver       Chrome  chrome_options=${chrome_options}
        
Open firefox
    Open Browser                        ${INIT_URL}     ${BROWSER}  

Jenkins input secrets
    ${SECRETS}                          Get File        /tmp/inti_password.txt
    Input Password                      ${input_SECRETS}  ${SECRETS}
    Log                                 ${SECRETS}
    Set Selenium Speed                  ${DELAY}
    Click Element                       ${button}
    Set Selenium Speed                  ${DELAY} 
Jenkins install plugin
    Capture Page Screenshot
    Set Selenium Speed                  ${DELAY}
    Click Element                       ${install_suggested}
    Capture Page Screenshot
    Wait Until Page Contains Element    ${saveandcontinue}
Create First Admin User
    Set Selenium Speed                  ${DELAY}
    ${html}                             Get Source
    Log                                 ${html}  
    Select Frame                        ${createadmin_iframe}
    Capture Page Screenshot  
    Set Selenium Speed                  ${DELAY} 
    Input Text                          ${input_USERNAME}   ${USERNAME}
    Input password                      ${input_PASSWORD1}  ${PASSWORD}
    Input password                      ${input_PASSWORD2}  ${PASSWORD}
    Input text                          ${input_FULL_NAME}  ${FULL_NAME}
    Input text                          ${input_EMAIL}      ${EMAIL}
    Capture Page Screenshot  
    Unselect Frame	
    Click Element                       ${saveandcontinue}
Instance configuration
    # Select Frame                        ${configuration_iframe}
    # Input Text                          ${input_Jenkins_URL}   ${Jenkins_URL}
    # Unselect Frame
    Capture Page Screenshot 
    Click Element                       ${saveandfinish}
    ${html}                             Get Source
    Log                                 ${html}  
    Capture Page Screenshot 
    Click Element                       ${installdone}
    Capture Page Screenshot  
*** Test Cases ***
start
    # Open Headless Chrome Browser to Page    ${INIT_URL}
    Open firefox
inti secrets
    Jenkins input secrets
install plugin    
    Jenkins install plugin
create admin user
    Create First Admin User
config Jenkins
    Instance configuration
    Close Browser