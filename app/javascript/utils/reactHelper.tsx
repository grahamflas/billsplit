import { createRoot } from "react-dom/client";
import type { ElementType } from "react";

export const mountComponent = (Component: ElementType, id: string): void => {
  const domNode = document.getElementById(id);

  if (domNode) {
    const rawProps = domNode.getAttribute("data-props") || "{}";
    const props = JSON.parse(rawProps);
    const root = createRoot(domNode);
    root.render(<Component {...props} />);
  }
};
