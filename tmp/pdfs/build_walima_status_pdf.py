from __future__ import annotations

from io import BytesIO
from pathlib import Path

from pypdf import PdfReader, PdfWriter
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_LEFT
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas
from reportlab.platypus import (
    KeepTogether,
    PageBreak,
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)


ROOT = Path('/Volumes/development/freelance/walima-projects/walima')
SOURCE = Path('/Users/nurullahsadekin/Downloads/WALIMA-APP-ONBOARDING (1).pdf')
TMP = ROOT / 'tmp/pdfs'
OUTPUT = ROOT / 'output/pdf/WALIMA_CLIENT_REPORT_IMPLEMENTATION_STATUS.pdf'
SUMMARY = TMP / 'status_summary.pdf'
APPENDIX = TMP / 'status_appendix.pdf'
STAMPED_SOURCE = TMP / 'client_report_stamped.pdf'

PAGE_W, PAGE_H = letter
PINK = colors.HexColor('#D92D68')
DARK = colors.HexColor('#20151A')
MUTED = colors.HexColor('#6B6267')
LIGHT = colors.HexColor('#F8F4F6')
GREEN = colors.HexColor('#16803C')
GREEN_BG = colors.HexColor('#EAF7EF')
AMBER = colors.HexColor('#A65D00')
AMBER_BG = colors.HexColor('#FFF4D6')
RED = colors.HexColor('#B42318')
RED_BG = colors.HexColor('#FDECEC')
BLUE = colors.HexColor('#175CD3')
BLUE_BG = colors.HexColor('#EAF2FF')
PURPLE = colors.HexColor('#6E3CBC')
PURPLE_BG = colors.HexColor('#F2ECFF')
BORDER = colors.HexColor('#E6DCE1')


styles = getSampleStyleSheet()
styles.add(
    ParagraphStyle(
        name='ReportTitle',
        parent=styles['Title'],
        fontName='Helvetica-Bold',
        fontSize=25,
        leading=29,
        textColor=DARK,
        spaceAfter=10,
    )
)
styles.add(
    ParagraphStyle(
        name='Subtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=15,
        textColor=MUTED,
    )
)
styles.add(
    ParagraphStyle(
        name='SectionTitle',
        parent=styles['Heading2'],
        fontName='Helvetica-Bold',
        fontSize=16,
        leading=20,
        textColor=DARK,
        spaceBefore=4,
        spaceAfter=9,
    )
)
styles.add(
    ParagraphStyle(
        name='BodySmall',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8.2,
        leading=11.2,
        textColor=DARK,
    )
)
styles.add(
    ParagraphStyle(
        name='Body',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=9.2,
        leading=13.2,
        textColor=DARK,
    )
)
styles.add(
    ParagraphStyle(
        name='SmallMuted',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=7.5,
        leading=10,
        textColor=MUTED,
    )
)
styles.add(
    ParagraphStyle(
        name='TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7.8,
        leading=9.5,
        textColor=colors.white,
    )
)
styles.add(
    ParagraphStyle(
        name='StatusText',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=7.2,
        leading=8.5,
        alignment=TA_CENTER,
    )
)


STATUS_ROWS = [
    ('01', 'Welcome Screen', 'FIXED', 'Language shows English; OTP help and contact support were added; Apple and Google use the requested side-by-side iOS layout.'),
    ('02', 'OTP / Email Verify', 'PARTIAL', '30-second timer, six-digit UI, paste/focus behavior, masked email, and country-code handling are present. WhatsApp-first delivery with SMS fallback still needs API-01.'),
    ('03', 'Profile For + Gender', 'FIXED', 'The requested choices are present. Profile manager submission now maps the selected relationship instead of always sending self.'),
    ('04', 'Name + Date of Birth', 'FIXED', 'The dark date picker and adult validation are present. The selected DOB is now sent instead of a hardcoded date.'),
    ('05', 'Religion + Country + City', 'PARTIAL', 'Dynamic religion/location flows exist, but the exact client option set, Bangladesh default coverage, and 64-district contract require lookup and location API alignment (API-03).'),
    ('06', 'Religious Practice', 'NOT FIXED', 'No supported onboarding field or persistence contract exists. Requires API-02 before the screen can be completed safely.'),
    ('07', 'Marriage Intention', 'NOT FIXED', 'The requested two-question values are not supported by the onboarding payload. Requires API-02.'),
    ('08', 'Email + Phone', 'FIXED', 'Email, phone, country code, availability checks, and verification-channel selection are implemented using the current API contract.'),
    ('09', 'Live with Family + Residency', 'FIXED', 'The existing onboarding payload already supports liveWithFamily and residencyStatus.'),
    ('10', 'Marital Status + Height + Diet', 'FIXED', 'Client marital options are filtered, the height selector remains supported, and Jain Vegetarian was removed from the displayed diet list.'),
    ('11', 'Education + Institute', 'PARTIAL', 'Qualification is integrated. Institute and additional institute are visible but are not part of the onboarding submission contract; API-02 is required.'),
    ('12', 'Income + Work + Profession', 'PARTIAL', 'Existing income/work/profession fields are used. hideIncome persistence and the exact BDT/work/profession datasets require API-02 and API-03.'),
    ('13', 'About Yourself', 'FIXED', 'Bio validation is 20-500 characters with a counter and quick-add chips. Verification type was removed from this step.'),
    ('14', 'Photo Upload', 'PARTIAL', 'Photo selection, camera, validation, guidance, skip, and X removal are present. The exact dashed-circle presentation still needs a small frontend refinement.'),
    ('15', 'Hobbies & Interests', 'PARTIAL', 'Minimum five selection is enforced. The requested ten-category, 86-plus-item taxonomy cannot be persisted by the current six-array contract; API-04 is required.'),
    ('16', 'Family Details', 'PARTIAL', 'Sibling range and family type are fixed using existing fields. Father/mother status values need dedicated fields and enums from API-05.'),
    ('17', 'Financial Status', 'NOT FIXED', 'The requested four values do not align with the current familyEconomicCondition enum. Requires API-05.'),
    ('18', 'Profile Complete', 'FIXED', 'Animated checkmark/confetti, message, and continuation to partner preferences are implemented.'),
    ('19', 'Partner Preferences Intro', 'FIXED', 'The existing intro flow already covers the benefits and continue/skip behavior.'),
    ('20', 'Preference Age + Height + Marital', 'PARTIAL', 'Age 18-60 and height 4ft0in-7ft0in defaults/limits are updated. The exact Open To All marital behavior still needs contract confirmation in API-06.'),
    ('21', 'Preference Religion + Mother Tongue', 'PARTIAL', 'Expanded mother-tongue choices are present. Open To All semantics and removal of partner community are not fully aligned; API-06 is required.'),
    ('22', 'Preference Country + City', 'NOT FIXED', 'The exact 24-country list, Any City option, top-city grouping, and complete city results require API-03/API-06.'),
    ('23', 'Preference Education', 'NOT FIXED', 'The exact multi-select education taxonomy must be supplied and accepted consistently by API-03/API-06.'),
    ('24', 'Preference Work + Profession + Income', 'NOT FIXED', 'Exact sector, profession, and income-range datasets plus Open To All semantics require API-03/API-06.'),
    ('25', 'Suggested Matches', 'PARTIAL', 'All returned matches are preselected; count, toggle, restricted-photo blur, and success copy are updated. A profile-level verified badge and explicit entitlement flags require API-07; badge rendering remains frontend work.'),
    ('26', 'Premium Plans', 'PARTIAL', 'Six FAQs and both support numbers are corrected. Guarantee, exact plan feature limits, and entitlement availability must be authoritative in API-08.'),
    ('27', 'Duplicate Field Removal', 'PARTIAL', 'Verification type and Jain diet duplication are fixed; profile manager uses Step 1. Partner community and every historical duplicate route still need final cleanup after API-06 alignment.'),
]


API_ITEMS = [
    {
        'id': 'API-01',
        'title': 'OTP delivery channel and fallback',
        'priority': 'P0 - blocks WhatsApp-first OTP',
        'endpoints': 'POST /auth/signin-with-otp; POST /auth/sign-up-with-otp; POST /auth/resend-otp; POST /auth/verify-otp',
        'gap': 'The app can request and verify OTP, but the response does not expose which transport was used or whether WhatsApp failed over to SMS.',
        'change': 'Accept deliveryChannel (email, whatsapp, sms) and fallbackChannel. For phone OTP, attempt WhatsApp first and fall back server-side to SMS. Return deliveryChannelUsed, fallbackAttempted, maskedIdentifier, otpLength, and retryAfterSeconds.',
        'acceptance': 'A phone request produces one logical OTP transaction; verification uses the same transaction regardless of transport; resend respects a server-supplied 30-second retry window.',
    },
    {
        'id': 'API-02',
        'title': 'Onboarding profile fields and persistence',
        'priority': 'P0 - blocks three requested onboarding sections',
        'endpoints': 'POST /users/onboarding; GET /users/profile; relevant PUT /users/profile/* endpoints',
        'gap': 'The current SignUpRequestBody has no religious-practice, two marriage-intention, institute, additional-institute, or hide-income fields.',
        'change': 'Add religiousPractice; connectionTimeline; marriageTimeline; institute; additionalInstitute; hideIncome. Recommended enum values: very_religious, moderately_religious, somewhat_religious, not_very_religious, prefer_not_to_say; 1_3_months, 3_6_months, 6_12_months, 1_2_years; within_6_months, 6_12_months, 1_2_years, 2_3_years, no_rush, decide_together.',
        'acceptance': 'Create, read, and update return the same canonical values; optional fields may be omitted; Open To All religion permits religiousPractice to be null.',
    },
    {
        'id': 'API-03',
        'title': 'Authoritative lookup and location datasets',
        'priority': 'P1 - blocks exact dropdown parity',
        'endpoints': 'GET /lookups; GET /countries; GET /cities',
        'gap': 'The client report requires exact religion, education, work-sector, profession, income, country, and city datasets. Current client fallbacks and returned datasets are not guaranteed to match.',
        'change': 'Publish versioned categories for religions, education_levels, work_sectors, professions, income_ranges, and mother_tongues. Country/city responses should include stable id, code, label, sortOrder, isActive, and isTopCity. Cities must support country, search, page, and size.',
        'acceptance': 'Bangladesh resolves all 64 districts; required country counts are available; mobile clients render labels but submit stable keys; removed keys remain backwards compatible during migration.',
    },
    {
        'id': 'API-04',
        'title': 'Ten-category interests taxonomy',
        'priority': 'P1 - blocks full hobbies requirement',
        'endpoints': 'GET /lookups?category=interests (or GET /interests/taxonomy); PUT /users/profile/interests',
        'gap': 'The existing update body uses six fixed arrays and cannot represent all ten client categories reliably.',
        'change': 'Return category objects with id, key, label, sortOrder, minimumSelection, and items. Accept selectedInterestIds as a flat stable-id array, or accept categories [{categoryKey, itemKeys}]. Keep the old six arrays during a deprecation window.',
        'acceptance': 'At least 86 active items can be returned; the server validates a minimum of five unique selections; GET returns the selected IDs after PUT.',
    },
    {
        'id': 'API-05',
        'title': 'Family status and financial enum alignment',
        'priority': 'P1 - blocks family/financial parity',
        'endpoints': 'PUT /users/profile/family; GET /users/profile/family',
        'gap': 'The current model has fatherProfession and motherProfession but no parent-status fields. Existing familyEconomicCondition values do not match the four client choices.',
        'change': 'Add fatherStatus and motherStatus. Support employed, self_employed_business, retired, not_employed, homemaker (mother), deceased, prefer_not_to_say. Align financialStatus to wealthy, upper_middle_class, middle_class, prefer_not_to_say, or publish a documented mapping from the legacy field.',
        'acceptance': 'All fields are optional; sibling counts accept 0-10; read-after-write preserves Prefer not to say without converting it to null.',
    },
    {
        'id': 'API-06',
        'title': 'Partner-preference filtering semantics',
        'priority': 'P1 - blocks exact preference behavior',
        'endpoints': 'PUT/GET /users/profile/preferences; GET /matches',
        'gap': 'Open To All is ambiguous across marital status, religion, mother tongue, location, education, profession, and income. Community is still supported although the client report removes it.',
        'change': 'Define Open To All as an omitted/empty filter or accept a canonical open_to_all key consistently. Document whether mixed selections containing open_to_all are rejected or normalized. Confirm whether communityPreference is deprecated. Accept stable lookup keys in all arrays.',
        'acceptance': 'Saved preferences and match-query behavior are identical; Open To All never accidentally filters out profiles; deprecated community data remains readable during migration.',
    },
    {
        'id': 'API-07',
        'title': 'Suggested-match verification and photo entitlements',
        'priority': 'P1 - blocks exact badge/blur rules',
        'endpoints': 'GET /matches; POST /connections/bulk-send',
        'gap': 'The match response has nested photo visibility and photo verification data, but no unambiguous profile-level verified badge or explicit can-view-photo entitlement.',
        'change': 'Return profileVerified (or verificationStatus), profilePhoto.canView, profilePhoto.blurRequired, and profilePhoto.blurReason. Keep visibilityStatus for compatibility. Bulk-send should return per-user success/failure and ignore already-connected profiles idempotently.',
        'acceptance': 'The client never infers verification from premium status; clear versus blurred photos are decided by response flags; all preselected eligible IDs can be submitted safely.',
    },
    {
        'id': 'API-08',
        'title': 'Premium plan content and entitlement contract',
        'priority': 'P2 - makes premium screen authoritative',
        'endpoints': 'GET /plans; GET /payments/subscription; POST /payments/initiate',
        'gap': 'Plan prices are dynamic, but the client report also specifies guarantee days and exact feature limits. These must not depend on hardcoded mobile copy.',
        'change': 'Return moneyBackGuaranteeDays, ordered features [{key,label,limit,enabled}], plan ranking, durationMonths, price, monthlyEquivalent, currency, and support configuration. Return active entitlements separately for runtime gating.',
        'acceptance': 'The five plans and their limits render from server data; purchase and subscription responses use the same plan IDs and feature keys; support/contact configuration is environment-safe.',
    },
]


def page_header_footer(c: canvas.Canvas, doc) -> None:
    c.saveState()
    c.setFillColor(PINK)
    c.rect(0, PAGE_H - 8, PAGE_W, 8, stroke=0, fill=1)
    c.setFillColor(MUTED)
    c.setFont('Helvetica', 7.5)
    c.drawString(0.55 * inch, 0.36 * inch, 'Walima onboarding implementation review - 27 August 2026')
    c.drawRightString(PAGE_W - 0.55 * inch, 0.36 * inch, f'Page {doc.page}')
    c.restoreState()


def p(text: str, style: str = 'Body') -> Paragraph:
    return Paragraph(text, styles[style])


def status_style(status: str):
    if status == 'FIXED':
        return GREEN, GREEN_BG
    if status == 'PARTIAL':
        return AMBER, AMBER_BG
    return RED, RED_BG


def build_summary() -> None:
    doc = SimpleDocTemplate(
        str(SUMMARY),
        pagesize=letter,
        leftMargin=0.62 * inch,
        rightMargin=0.62 * inch,
        topMargin=0.62 * inch,
        bottomMargin=0.58 * inch,
        title='Walima Client Report - Implementation Status',
        author='Walima App Engineering Review',
    )
    story = [
        Spacer(1, 0.15 * inch),
        p('WALIMA APP', 'SmallMuted'),
        p('Client Report Implementation Status', 'ReportTitle'),
        p('Review of WALIMA - App Onboarding Flow | Source dated May 2026 | App review dated 27 August 2026', 'Subtitle'),
        Spacer(1, 0.25 * inch),
    ]

    counts = {'FIXED': 0, 'PARTIAL': 0, 'NOT FIXED': 0}
    for _, _, status, _ in STATUS_ROWS:
        counts[status] += 1

    cards = []
    for label, color, bg in [
        ('FIXED', GREEN, GREEN_BG),
        ('PARTIAL', AMBER, AMBER_BG),
        ('NOT FIXED', RED, RED_BG),
    ]:
        cards.append(
            Table(
                [[p(str(counts[label]), 'SectionTitle')], [p(label, 'StatusText')]],
                colWidths=[1.68 * inch],
                rowHeights=[0.55 * inch, 0.32 * inch],
                style=TableStyle([
                    ('BACKGROUND', (0, 0), (-1, -1), bg),
                    ('TEXTCOLOR', (0, 0), (-1, -1), color),
                    ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
                    ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
                    ('BOX', (0, 0), (-1, -1), 0.7, color),
                    ('ROUNDEDCORNERS', [8]),
                ]),
            )
        )
    story.append(Table([cards], colWidths=[1.78 * inch] * 3, hAlign='LEFT'))
    story.extend([
        Spacer(1, 0.28 * inch),
        p('Review outcome', 'SectionTitle'),
        p('<b>Frontend-only fixes were adopted without introducing new endpoint paths or changing the existing request-envelope shapes.</b> Items marked Partial include a completed subset plus either a remaining UI refinement or backend dependency. Items marked Not Fixed are intentionally deferred because implementing them safely requires an API contract change.'),
        Spacer(1, 0.16 * inch),
        Table(
            [
                [p('What is complete', 'TableHeader'), p('What remains', 'TableHeader')],
                [
                    p('DOB and profile-manager submission; OTP timing/masking; registration verification placement; bio rules; marital/diet/sibling rules; family type; photo removal; minimum hobbies; profile-complete animation; preference ranges; suggested-match preselection/count; FAQ and support number.'),
                    p('WhatsApp OTP fallback; new onboarding fields; exact lookup datasets; ten-category interest persistence; parent statuses; financial enum alignment; preference Open To All semantics; match verification/entitlement flags; authoritative premium feature limits.'),
                ],
            ],
            colWidths=[2.64 * inch, 2.64 * inch],
            style=TableStyle([
                ('BACKGROUND', (0, 0), (-1, 0), DARK),
                ('BOX', (0, 0), (-1, -1), 0.6, BORDER),
                ('INNERGRID', (0, 0), (-1, -1), 0.4, BORDER),
                ('VALIGN', (0, 0), (-1, -1), 'TOP'),
                ('LEFTPADDING', (0, 0), (-1, -1), 9),
                ('RIGHTPADDING', (0, 0), (-1, -1), 9),
                ('TOPPADDING', (0, 0), (-1, -1), 8),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 8),
            ]),
        ),
        Spacer(1, 0.25 * inch),
        p('How to read this document', 'SectionTitle'),
        p('The next 10 pages preserve the client-supplied PDF and carry a review stamp. The detailed item-by-item matrix follows those source pages. The final appendix specifies the API changes needed to complete every backend-dependent requirement.'),
        Spacer(1, 0.16 * inch),
        Table(
            [[p('<b>Scope note</b><br/>This status reflects the current local Flutter source. It is not a production API certification and does not claim backend behavior that cannot be verified from the mobile repository.', 'BodySmall')]],
            colWidths=[5.28 * inch],
            style=TableStyle([
                ('BACKGROUND', (0, 0), (-1, -1), BLUE_BG),
                ('BOX', (0, 0), (-1, -1), 0.7, BLUE),
                ('LEFTPADDING', (0, 0), (-1, -1), 10),
                ('RIGHTPADDING', (0, 0), (-1, -1), 10),
                ('TOPPADDING', (0, 0), (-1, -1), 9),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 9),
            ]),
        ),
    ])
    doc.build(story, onFirstPage=page_header_footer, onLaterPages=page_header_footer)


def build_appendix() -> None:
    doc = SimpleDocTemplate(
        str(APPENDIX),
        pagesize=letter,
        leftMargin=0.5 * inch,
        rightMargin=0.5 * inch,
        topMargin=0.52 * inch,
        bottomMargin=0.55 * inch,
        title='Walima Implementation Matrix and API Appendix',
        author='Walima App Engineering Review',
    )
    story = [
        p('Detailed Implementation Matrix', 'ReportTitle'),
        p('FIXED means the requested behavior is present in the current Flutter source. PARTIAL means only the stated subset is complete. NOT FIXED means the requirement remains deferred.', 'Subtitle'),
        Spacer(1, 0.15 * inch),
    ]

    def make_status_table(rows):
        data = [[p('ID', 'TableHeader'), p('Client requirement', 'TableHeader'), p('Status', 'TableHeader'), p('Current implementation and remaining work', 'TableHeader')]]
        for row_id, requirement, status, detail in rows:
            fg, bg = status_style(status)
            status_badge = Table(
                [[Paragraph(status.replace(' ', '<br/>'), ParagraphStyle('inline', parent=styles['StatusText'], textColor=fg))]],
                colWidths=[0.68 * inch],
                style=TableStyle([
                    ('BACKGROUND', (0, 0), (-1, -1), bg),
                    ('BOX', (0, 0), (-1, -1), 0.5, fg),
                    ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
                    ('LEFTPADDING', (0, 0), (-1, -1), 3),
                    ('RIGHTPADDING', (0, 0), (-1, -1), 3),
                    ('TOPPADDING', (0, 0), (-1, -1), 4),
                    ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
                ]),
            )
            data.append([p(row_id, 'BodySmall'), p(requirement, 'BodySmall'), status_badge, p(detail, 'BodySmall')])
        table = Table(data, repeatRows=1, colWidths=[0.33 * inch, 1.44 * inch, 0.78 * inch, 4.05 * inch])
        table.setStyle(TableStyle([
            ('BACKGROUND', (0, 0), (-1, 0), DARK),
            ('VALIGN', (0, 0), (-1, -1), 'TOP'),
            ('BOX', (0, 0), (-1, -1), 0.65, BORDER),
            ('INNERGRID', (0, 0), (-1, -1), 0.35, BORDER),
            ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, LIGHT]),
            ('LEFTPADDING', (0, 0), (-1, -1), 5),
            ('RIGHTPADDING', (0, 0), (-1, -1), 5),
            ('TOPPADDING', (0, 0), (-1, -1), 6),
            ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
        ]))
        return table

    story.extend([
        make_status_table(STATUS_ROWS[:16]),
        PageBreak(),
        p('Detailed Implementation Matrix - continued', 'SectionTitle'),
        make_status_table(STATUS_ROWS[16:]),
        PageBreak(),
        p('Required API Changes', 'ReportTitle'),
    ])
    story.append(p('The following contracts are proposed implementation requirements. Existing endpoint paths are reused where possible. Field names are recommendations and should be finalized jointly by mobile and backend teams.', 'Subtitle'))
    story.append(Spacer(1, 0.15 * inch))

    priority_data = [[p('ID', 'TableHeader'), p('Priority', 'TableHeader'), p('Blocks', 'TableHeader')]]
    blocks = {
        'API-01': 'WhatsApp-first OTP',
        'API-02': 'Religious practice, marriage intention, institute, hide income',
        'API-03': 'Exact lookup/location parity',
        'API-04': 'Ten interest categories',
        'API-05': 'Parent status and financial values',
        'API-06': 'Open To All preference behavior',
        'API-07': 'Verified badge and photo gating',
        'API-08': 'Authoritative premium content',
    }
    for item in API_ITEMS:
        priority_data.append([p(item['id'], 'BodySmall'), p(item['priority'], 'BodySmall'), p(blocks[item['id']], 'BodySmall')])
    priority_table = Table(priority_data, repeatRows=1, colWidths=[0.72 * inch, 2.15 * inch, 3.73 * inch])
    priority_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), PURPLE),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, PURPLE_BG]),
        ('BOX', (0, 0), (-1, -1), 0.6, BORDER),
        ('INNERGRID', (0, 0), (-1, -1), 0.35, BORDER),
        ('VALIGN', (0, 0), (-1, -1), 'TOP'),
        ('LEFTPADDING', (0, 0), (-1, -1), 6),
        ('RIGHTPADDING', (0, 0), (-1, -1), 6),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))
    story.extend([priority_table, Spacer(1, 0.22 * inch)])

    for item in API_ITEMS:
        if item['id'] == 'API-08':
            story.append(PageBreak())
        title = Table(
            [[p(item['id'], 'TableHeader'), Paragraph(item['title'], ParagraphStyle('apiTitle', parent=styles['Body'], fontName='Helvetica-Bold', fontSize=11, textColor=colors.white))]],
            colWidths=[0.75 * inch, 5.85 * inch],
            style=TableStyle([
                ('BACKGROUND', (0, 0), (-1, -1), DARK),
                ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
                ('LEFTPADDING', (0, 0), (-1, -1), 8),
                ('RIGHTPADDING', (0, 0), (-1, -1), 8),
                ('TOPPADDING', (0, 0), (-1, -1), 7),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 7),
            ]),
        )
        detail = Table(
            [
                [p('<b>Priority</b>', 'BodySmall'), p(item['priority'], 'BodySmall')],
                [p('<b>Affected endpoints</b>', 'BodySmall'), p(item['endpoints'], 'BodySmall')],
                [p('<b>Current gap</b>', 'BodySmall'), p(item['gap'], 'BodySmall')],
                [p('<b>Required change</b>', 'BodySmall'), p(item['change'], 'BodySmall')],
                [p('<b>Acceptance criteria</b>', 'BodySmall'), p(item['acceptance'], 'BodySmall')],
            ],
            colWidths=[1.18 * inch, 5.42 * inch],
            style=TableStyle([
                ('ROWBACKGROUNDS', (0, 0), (-1, -1), [colors.white, LIGHT]),
                ('BOX', (0, 0), (-1, -1), 0.6, BORDER),
                ('INNERGRID', (0, 0), (-1, -1), 0.35, BORDER),
                ('VALIGN', (0, 0), (-1, -1), 'TOP'),
                ('LEFTPADDING', (0, 0), (-1, -1), 7),
                ('RIGHTPADDING', (0, 0), (-1, -1), 7),
                ('TOPPADDING', (0, 0), (-1, -1), 5),
                ('BOTTOMPADDING', (0, 0), (-1, -1), 5),
            ]),
        )
        story.append(KeepTogether([title, detail, Spacer(1, 0.18 * inch)]))

    story.extend([
        Spacer(1, 0.1 * inch),
        p('Recommended implementation sequence', 'SectionTitle'),
        p('<b>1.</b> Finalize API-02 and API-05 payloads. <b>2.</b> Publish API-03/API-04 lookup contracts. <b>3.</b> Define API-06 Open To All behavior. <b>4.</b> Add API-01 transport metadata and fallback. <b>5.</b> Add API-07/API-08 entitlement fields. <b>6.</b> Complete the remaining Flutter screens and run end-to-end contract tests.'),
    ])
    doc.build(story, onFirstPage=page_header_footer, onLaterPages=page_header_footer)


def build_stamped_source() -> None:
    reader = PdfReader(str(SOURCE))
    writer = PdfWriter()
    for index, source_page in enumerate(reader.pages, start=1):
        width = float(source_page.mediabox.width)
        height = float(source_page.mediabox.height)
        buffer = BytesIO()
        c = canvas.Canvas(buffer, pagesize=(width, height))
        c.saveState()
        c.setFillColor(colors.Color(1, 1, 1, alpha=0.94))
        c.roundRect(width - 178, height - 25, 166, 16, 5, stroke=0, fill=1)
        c.setStrokeColor(PINK)
        c.setLineWidth(0.6)
        c.roundRect(width - 178, height - 25, 166, 16, 5, stroke=1, fill=0)
        c.setFillColor(PINK)
        c.setFont('Helvetica-Bold', 6.5)
        c.drawCentredString(width - 95, height - 19.5, 'IMPLEMENTATION REVIEW - 27 AUG 2026')
        c.setFillColor(colors.Color(1, 1, 1, alpha=0.94))
        c.rect(0, 0, width, 14, stroke=0, fill=1)
        c.setFillColor(MUTED)
        c.setFont('Helvetica', 6.2)
        c.drawString(18, 5, 'CLIENT SOURCE PAGE - preserved for reference')
        c.drawRightString(width - 18, 5, f'Source {index} of {len(reader.pages)} | Status matrix follows')
        c.restoreState()
        c.save()
        buffer.seek(0)
        overlay_page = PdfReader(buffer).pages[0]
        source_page.merge_page(overlay_page)
        writer.add_page(source_page)
    with STAMPED_SOURCE.open('wb') as stream:
        writer.write(stream)


def combine_final() -> None:
    writer = PdfWriter()
    for pdf_path in [SUMMARY, STAMPED_SOURCE, APPENDIX]:
        reader = PdfReader(str(pdf_path))
        for page in reader.pages:
            writer.add_page(page)
    writer.add_metadata({
        '/Title': 'Walima Client Report - Implementation Status and API Requirements',
        '/Author': 'Walima App Engineering Review',
        '/Subject': 'Fixed, partial, deferred, and required API changes',
        '/Keywords': 'Walima, onboarding, implementation status, API requirements',
    })
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    with OUTPUT.open('wb') as stream:
        writer.write(stream)


def validate() -> None:
    reader = PdfReader(str(OUTPUT))
    if len(reader.pages) < 16:
        raise RuntimeError(f'Unexpected page count: {len(reader.pages)}')
    if reader.is_encrypted:
        raise RuntimeError('Final PDF must not be encrypted')
    text = '\n'.join((page.extract_text() or '') for page in reader.pages)
    required = [
        'Client Report Implementation Status',
        'Detailed Implementation Matrix',
        'Required API Changes',
        'API-01',
        'API-08',
        'WhatsApp-first OTP',
    ]
    missing = [value for value in required if value not in text]
    if missing:
        raise RuntimeError(f'Missing required text: {missing}')
    print(f'Created {OUTPUT}')
    print(f'Pages: {len(reader.pages)}')
    print(f'Bytes: {OUTPUT.stat().st_size}')


if __name__ == '__main__':
    TMP.mkdir(parents=True, exist_ok=True)
    build_summary()
    build_stamped_source()
    build_appendix()
    combine_final()
    validate()
