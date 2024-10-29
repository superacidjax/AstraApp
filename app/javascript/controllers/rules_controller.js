import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  // addNewRule(event) {
  //   event.preventDefault();
  //
  //   const link = event.currentTarget;
  //   const containerId = link.dataset.containerId;
  //   const container = document.getElementById(containerId);
  //   const lastRule = container.querySelector(".rule-item:last-of-type");
  //
  //   let url = link.getAttribute("href");
  //
  //   if (lastRule) {
  //     const lastRuleId = lastRule.id.replace("rule-", "");
  //     console.log("Last Rule ID:", lastRuleId);
  //     url += `&last_rule_id=${lastRuleId}`;
  //   } else {
  //     console.log("No previous rule found.");
  //   }
  //
  //   Turbo.visit(url, { action: "replace" });
  // }
}
