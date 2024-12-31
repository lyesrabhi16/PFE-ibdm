import { Dropdown, theme } from "antd";
import React from "react";
import { LanguageSwitchButtonViewProps } from "#/types";
import { log } from "#/utils";

const LanguageSwitchButton = (props: LanguageSwitchButtonViewProps) => {
  log("LanguageSwitchButton Props: ", props);

  const { useToken } = theme;
  const { token } = useToken();

  const contentStyle: React.CSSProperties = {
    backgroundColor: token.colorBgElevated,
    borderRadius: token.borderRadiusLG,
    boxShadow: token.boxShadowSecondary,
    textAlign: "center",
  };

  const menuStyle: React.CSSProperties = {
    boxShadow: "none",
  };

  return (
    <div className="group">
      <Dropdown.Button
        onClick={props.switchLanguage}
        menu={{
          items: props.items,
          selectable: true,
          defaultSelectedKeys: [props.language],
          onClick: props.onMenuClick,
        }}
        className="group m-0 rounded-none"
        placement="bottomLeft"
        arrow={{
          pointAtCenter: true,
        }}
        dropdownRender={(menu) => {
          return <div style={contentStyle}>
            {React.cloneElement(menu as React.ReactElement, { style: menuStyle })}
          </div>;
        }}
      >
          {props.language}        
      </Dropdown.Button>
    </div>
  );
};

export default LanguageSwitchButton;
