import React                   from 'react';

/* component styles */
import { styles } from './styles.scss';

export default function TopBar(props) {
  return (
    <div className={styles}>
      <div className="top-bar">Default Ethereum Address: {window.web3.eth.defaultAccount}</div>
    </div>
  );
}
