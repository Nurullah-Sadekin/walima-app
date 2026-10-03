# Walima Jira report — In Review and backend dependencies

**Checked:** 26 September 2026 (Asia/Dhaka)  
**Source:** Jira project `MOBL` on [Walima's Atlassian site](https://iqbalhossain1095.atlassian.net).  
**Method:** Live Jira query for `project = MOBL AND status = "In Review"`, followed by project-wide searches for API mentions and flagged impediments. This report reflects Jira issue status and text, not a code audit.

## In Review — 15 issues

All 15 issues are assigned to Md. Nurullah Sadekin and have Medium priority in Jira.

| Jira issue | Work item |
| --- | --- |
| [MOBL-6](https://iqbalhossain1095.atlassian.net/browse/MOBL-6) | Add “Open to all” for partner district preference |
| [MOBL-20](https://iqbalhossain1095.atlassian.net/browse/MOBL-20) | Adjust input field border roundness |
| [MOBL-5](https://iqbalhossain1095.atlassian.net/browse/MOBL-5) | Remove “Married” from partner marital status lookup |
| [MOBL-4](https://iqbalhossain1095.atlassian.net/browse/MOBL-4) | Add “Open to all” for partner religion preference |
| [MOBL-7](https://iqbalhossain1095.atlassian.net/browse/MOBL-7) | Fix partner preference selection and simplify the selector |
| [MOBL-3](https://iqbalhossain1095.atlassian.net/browse/MOBL-3) | Replace photo guideline image with an original or licensed image |
| [MOBL-2](https://iqbalhossain1095.atlassian.net/browse/MOBL-2) | Add profile photo guideline copy |
| [MOBL-1](https://iqbalhossain1095.atlassian.net/browse/MOBL-1) | Support nested work sector categories |
| [MOBL-21](https://iqbalhossain1095.atlassian.net/browse/MOBL-21) | Hide Institute when “No formal education” is selected |
| [MOBL-19](https://iqbalhossain1095.atlassian.net/browse/MOBL-19) | Add or clarify “Where do you live?” residency field |
| [MOBL-18](https://iqbalhossain1095.atlassian.net/browse/MOBL-18) | Show “I pray five times” when “Very religious” is selected |
| [MOBL-17](https://iqbalhossain1095.atlassian.net/browse/MOBL-17) | Resolve self versus partner religion lookup API ambiguity |
| [MOBL-15](https://iqbalhossain1095.atlassian.net/browse/MOBL-15) | Limit self-religion choices to Islam and Others |
| [MOBL-14](https://iqbalhossain1095.atlassian.net/browse/MOBL-14) | Enforce minimum age 18 in DOB year selection |
| [MOBL-10](https://iqbalhossain1095.atlassian.net/browse/MOBL-10) | Save onboarding profile data as a temporary draft until verification |

## Backend/API dependencies recorded in Jira — 4 issues

Jira has **no status named “Backend Dependency”** in the `MOBL` workflow. These are the `MOBL` issues whose current text explicitly mentions an API or API contract. Only MOBL-16 is formally flagged **Impediment**.

| Jira issue | Current status | Dependency or decision recorded in Jira |
| --- | --- | --- |
| [MOBL-5](https://iqbalhossain1095.atlassian.net/browse/MOBL-5) | In Review | Partner marital-status lookup API and dashboard filter should remove “Married”. |
| [MOBL-17](https://iqbalhossain1095.atlassian.net/browse/MOBL-17) | In Review | Confirm whether self and partner religion use one lookup API or separate APIs. |
| [MOBL-9](https://iqbalhossain1095.atlassian.net/browse/MOBL-9) | To Do | Add API support for Shortlist versus Contact button state after users connect. |
| [MOBL-16](https://iqbalhossain1095.atlassian.net/browse/MOBL-16) | To Do; flagged Impediment | Determine whether changing onboarding flow order requires an API contract change. |

**Overlap:** MOBL-5 and MOBL-17 are both In Review and API-related. The four backend/API items are a text-based grouping, not a Jira workflow status or a confirmed list of blocked issues.
