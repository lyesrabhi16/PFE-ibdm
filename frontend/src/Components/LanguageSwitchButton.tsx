import type { MenuProps } from "antd";
import { Button, Dropdown, theme } from "antd";
import { useStore } from "#/store";
import { languages } from "#/types";
import { DownOutlined } from "@ant-design/icons";
import React, { useEffect } from "react";
const LanguageSwitchButton = () => {
  const { language, setLanguage } = useStore();

  const onMenuClick: MenuProps["onClick"] = (e) => {
    setLanguage(e.key as languages);
  };

  const switchLanguage = () => {
    const _languages = Object.values(languages);
    const index = _languages.indexOf(language);
    const lang = _languages[(index + 1) % _languages.length];
    setLanguage(lang);
  };

  const items = Object.values(languages).map((lang) => ({
    key: lang,
    value: lang,
    label: lang,
  }));
  const { useToken } = theme;
  const { token } = useToken();

  const contentStyle: React.CSSProperties = {
    backgroundColor: token.colorBgElevated,
    borderRadius: token.borderRadiusLG,
    boxShadow: token.boxShadowSecondary,
    textAlign: "center",
  };

  const menuStyle: React.CSSProperties = {
    boxShadow: 'none',
  };

  useEffect(() => {
    const _dropdown_items = document.querySelectorAll('.ant-dropdown-menu-item');
    _dropdown_items.forEach((item) => {
        if (item.getAttribute("value") === language) {
            item.classList.add('ant-dropdown-menu-item-selected');
        }
        else{
            item.classList.remove('ant-dropdown-menu-item-selected');
        }
    });
  
    return () => {
    }
  }, [language])
  

  return (
    <div className="group">
      <Dropdown 
        menu={{
          items,
          selectable: true,
          defaultSelectedKeys: [language],
          onClick: onMenuClick,
        }}
        className="group m-0 rounded-none"
        placement="bottom"
        arrow={{
          pointAtCenter: true,
        }}
        dropdownRender={(menu) => {
          return <div style={contentStyle}>
            {React.cloneElement(menu as React.ReactElement, { style: menuStyle })}
          </div>;
        }}
      >
        <Button onClick={switchLanguage}>
          {language}
          <DownOutlined />
        </Button>
        
      </Dropdown>
    </div>
  );
};

export default LanguageSwitchButton;
