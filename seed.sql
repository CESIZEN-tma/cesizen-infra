-- =============================================================
-- CesiZen - Seed data
-- Run AFTER the API has started at least once (admin seeded)
-- =============================================================

DO $$
DECLARE
    v_admin_id UUID;

    -- Tags
    tag_stress        UUID := gen_random_uuid();
    tag_anxiete       UUID := gen_random_uuid();
    tag_respiration   UUID := gen_random_uuid();
    tag_coh_card      UUID := gen_random_uuid();
    tag_sommeil       UUID := gen_random_uuid();
    tag_mindfulness   UUID := gen_random_uuid();
    tag_bien_etre     UUID := gen_random_uuid();
    tag_energie       UUID := gen_random_uuid();

    -- Pages
    p_stress_comprendre  UUID := gen_random_uuid();
    p_stress_burnout     UUID := gen_random_uuid();
    p_stress_travail     UUID := gen_random_uuid();
    p_anxiete_crises     UUID := gen_random_uuid();
    p_anxiete_tcc        UUID := gen_random_uuid();
    p_resp_bases         UUID := gen_random_uuid();
    p_resp_coh           UUID := gen_random_uuid();
    p_resp_crise         UUID := gen_random_uuid();
    p_sommeil_cycles     UUID := gen_random_uuid();
    p_sommeil_stress     UUID := gen_random_uuid();
    p_mind_intro         UUID := gen_random_uuid();
    p_mind_quotidien     UUID := gen_random_uuid();
    p_energie_alim       UUID := gen_random_uuid();
    p_energie_hydrat     UUID := gen_random_uuid();

    -- Quizzes
    q1 UUID := gen_random_uuid();
    q2 UUID := gen_random_uuid();
    q3 UUID := gen_random_uuid();
    q4 UUID := gen_random_uuid();
    q5 UUID := gen_random_uuid();

    -- Menu items
    m_home       UUID := gen_random_uuid();
    m_sante_h    UUID := gen_random_uuid();
    m_stress     UUID := gen_random_uuid();
    m_burnout    UUID := gen_random_uuid();
    m_anxiete    UUID := gen_random_uuid();
    m_tcc        UUID := gen_random_uuid();
    m_resp_h     UUID := gen_random_uuid();
    m_resp_bases UUID := gen_random_uuid();
    m_resp_coh   UUID := gen_random_uuid();
    m_resp_crise UUID := gen_random_uuid();
    m_sommeil_h  UUID := gen_random_uuid();
    m_sommeil    UUID := gen_random_uuid();
    m_som_stress UUID := gen_random_uuid();
    m_mind_h     UUID := gen_random_uuid();
    m_mind_intro UUID := gen_random_uuid();
    m_mind_quot  UUID := gen_random_uuid();
    m_energie_h  UUID := gen_random_uuid();
    m_alim       UUID := gen_random_uuid();
    m_hydrat     UUID := gen_random_uuid();

    qq UUID;

BEGIN
    SELECT id INTO v_admin_id FROM administrators WHERE email = 'admin@cesizen.fr' LIMIT 1;
    IF v_admin_id IS NULL THEN
        RAISE EXCEPTION 'Admin not found. Start the API at least once first.';
    END IF;

    -- ===========================================================
    -- TAGS
    -- ===========================================================
    INSERT INTO information_tags (id, label, creation_time) VALUES
        (tag_stress,      'Stress',              NOW()),
        (tag_anxiete,     'Anxiété',             NOW()),
        (tag_respiration, 'Respiration',         NOW()),
        (tag_coh_card,    'Cohérence cardiaque', NOW()),
        (tag_sommeil,     'Sommeil',             NOW()),
        (tag_mindfulness, 'Pleine conscience',   NOW()),
        (tag_bien_etre,   'Bien-être',           NOW()),
        (tag_energie,     'Énergie & Nutrition', NOW())
    ON CONFLICT DO NOTHING;

    -- ===========================================================
    -- INFORMATION PAGES
    -- ===========================================================

    -- Catégorie Santé mentale — Stress
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_stress_comprendre, 'Comprendre le stress', 'Les mécanismes du stress et comment y répondre efficacement.',
'<h2>Qu''est-ce que le stress ?</h2>
<p>Le stress est une réaction de l''organisme face à une situation perçue comme exigeante. En quantité raisonnable, il est un moteur. Chronique, il devient un ennemi.</p>
<h2>Le cycle du stress</h2>
<p>Face à un stresseur, le cerveau libère cortisol et adrénaline : cœur qui s''accélère, muscles tendus, respiration superficielle. Ce mécanisme ancestral de survie devient problématique quand il est activé en permanence.</p>
<h2>Les 3 stades</h2>
<ul>
  <li><strong>Alarme :</strong> mobilisation des ressources.</li>
  <li><strong>Résistance :</strong> l''organisme tente de s''adapter.</li>
  <li><strong>Épuisement :</strong> les réserves sont à sec.</li>
</ul>
<h2>Que faire ?</h2>
<p>Identifier ses stresseurs, pratiquer la respiration guidée et maintenir des routines de récupération (sommeil, activité physique, pleine conscience).</p>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_stress_burnout, 'Reconnaître le burnout', 'Comment identifier l''épuisement professionnel avant qu''il ne soit trop tard.',
'<h2>Burnout : définition</h2>
<p>Le burnout, ou épuisement professionnel, est un syndrome résultant d''un stress chronique au travail. L''OMS le reconnaît comme un phénomène occupationnel depuis 2019.</p>
<h2>Les signes avant-coureurs</h2>
<ul>
  <li>Fatigue intense qui ne disparaît pas au repos.</li>
  <li>Cynisme et détachement vis-à-vis du travail.</li>
  <li>Sentiment d''inefficacité et perte de confiance.</li>
  <li>Troubles du sommeil, irritabilité, maux de tête.</li>
</ul>
<h2>Les 3 dimensions du burnout (Maslach)</h2>
<ol>
  <li><strong>Épuisement émotionnel :</strong> sentiment d''être vidé.</li>
  <li><strong>Dépersonnalisation :</strong> attitude froide envers les autres.</li>
  <li><strong>Réduction de l''accomplissement personnel.</strong></li>
</ol>
<h2>Prévention</h2>
<p>Poser des limites claires, prendre des pauses régulières, pratiquer des techniques de décompression (cohérence cardiaque, méditation) et ne pas hésiter à consulter un professionnel.</p>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_stress_travail, 'Gérer le stress au travail', 'Stratégies concrètes pour réduire la pression professionnelle au quotidien.',
'<h2>Pourquoi le travail stresse-t-il autant ?</h2>
<p>Charge excessive, manque d''autonomie, conflits relationnels, insécurité… Les sources de stress au travail sont multiples. Le modèle de Karasek identifie deux facteurs clés : la demande psychologique et la latitude décisionnelle.</p>
<h2>Techniques rapides</h2>
<h3>La règle des 2 minutes</h3>
<p>Si une tâche prend moins de 2 minutes, faites-la immédiatement. Sinon, planifiez-la. Cela réduit l''accumulation mentale.</p>
<h3>La respiration avant une réunion</h3>
<p>3 cycles de cohérence cardiaque (5s inspiration / 5s expiration) suffisent à abaisser significativement votre niveau de cortisol.</p>
<h2>Organisation</h2>
<ul>
  <li>Décomposez les grands projets en micro-tâches.</li>
  <li>Bloquez des plages de travail profond sans interruption.</li>
  <li>Finissez la journée avec un rituel de déconnexion.</li>
</ul>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- Catégorie Santé mentale — Anxiété
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_anxiete_crises, 'Gérer les crises d''anxiété', 'Techniques d''urgence pour traverser une crise d''anxiété ou une attaque de panique.',
'<h2>Qu''est-ce qu''une crise d''anxiété ?</h2>
<p>Une crise d''anxiété (ou attaque de panique) est une montée soudaine d''une peur intense accompagnée de symptômes physiques : palpitations, oppression thoracique, vertiges, sensation d''irréalité.</p>
<h2>Technique d''ancrage 5-4-3-2-1</h2>
<p>Pendant la crise, nommez :</p>
<ul>
  <li>5 choses que vous <strong>voyez</strong></li>
  <li>4 choses que vous <strong>touchez</strong></li>
  <li>3 choses que vous <strong>entendez</strong></li>
  <li>2 choses que vous <strong>sentez</strong></li>
  <li>1 chose que vous <strong>goûtez</strong></li>
</ul>
<h2>La respiration carrée</h2>
<p>Inspirez 4s → retenez 4s → expirez 4s → retenez 4s. Ce pattern régule le système nerveux autonome en moins de 2 minutes.</p>
<h2>Ce qu''il ne faut pas faire</h2>
<ul>
  <li>Ne pas fuir systématiquement la situation anxiogène (renforcement de l''évitement).</li>
  <li>Ne pas hyperventiler.</li>
  <li>Ne pas se répéter "je vais mourir" — une crise d''anxiété est inconfortable mais pas dangereuse.</li>
</ul>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_anxiete_tcc, 'La thérapie cognitive et comportementale', 'Comment la TCC aide à restructurer les pensées anxieuses.',
'<h2>Qu''est-ce que la TCC ?</h2>
<p>La thérapie cognitive et comportementale (TCC) est une approche psychothérapeutique qui agit sur les pensées dysfonctionnelles et les comportements d''évitement. Elle est la plus étudiée scientifiquement pour les troubles anxieux.</p>
<h2>Le triangle pensées-émotions-comportements</h2>
<p>Nos pensées influencent nos émotions, qui influencent nos comportements. En modifiant les pensées automatiques négatives, on modifie la réponse émotionnelle.</p>
<h2>Exercice : la restructuration cognitive</h2>
<ol>
  <li>Identifiez la pensée automatique (ex : "je vais échouer").</li>
  <li>Évaluez sa réalité : quelle preuve ai-je ? Quelle contre-preuve ?</li>
  <li>Formulez une pensée alternative réaliste (ex : "j''ai déjà réussi dans des situations similaires").</li>
</ol>
<h2>Quand consulter ?</h2>
<p>Si l''anxiété impacte significativement votre vie quotidienne, un suivi TCC avec un professionnel est recommandé. Une série de 8 à 20 séances est généralement suffisante pour des résultats durables.</p>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- Catégorie Respiration
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_resp_bases, 'Les bases de la respiration consciente', 'Comprendre le lien entre respiration et système nerveux.',
'<h2>Respiration et système nerveux</h2>
<p>La respiration est le seul processus autonome que nous pouvons contrôler consciemment. En modifiant notre rythme respiratoire, nous influençons directement le système nerveux autonome — et donc notre niveau de stress.</p>
<h2>Deux modes</h2>
<ul>
  <li><strong>Sympathique (stress) :</strong> respiration rapide et thoracique. Prépare au combat ou à la fuite.</li>
  <li><strong>Parasympathique (repos) :</strong> respiration lente et abdominale. Favorise la récupération.</li>
</ul>
<h2>Comment respirer "correctement" ?</h2>
<ol>
  <li>Posez une main sur le ventre et l''autre sur la poitrine.</li>
  <li>Inspirez par le nez : le ventre doit se soulever, pas la poitrine.</li>
  <li>Expirez lentement par la bouche.</li>
  <li>L''expiration doit être plus longue que l''inspiration.</li>
</ol>
<p>5 minutes de cette respiration abdominale abaissent la fréquence cardiaque et réduisent le cortisol.</p>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_coh, 'La cohérence cardiaque', 'La technique de respiration la plus étudiée pour réduire le stress.',
'<h2>Définition</h2>
<p>La cohérence cardiaque est un état physiologique dans lequel la variabilité de la fréquence cardiaque se synchronise avec la respiration. Elle améliore la communication cœur-cerveau et réduit le cortisol.</p>
<h2>La règle des 365</h2>
<ul>
  <li><strong>3</strong> fois par jour</li>
  <li><strong>6</strong> respirations par minute (5s inspiration / 5s expiration)</li>
  <li><strong>5</strong> minutes par session</li>
</ul>
<h2>Bénéfices prouvés</h2>
<ul>
  <li>Réduction du cortisol jusqu''à 23 % après 3 mois.</li>
  <li>Meilleure régulation émotionnelle.</li>
  <li>Amélioration de la qualité du sommeil.</li>
  <li>Renforcement immunitaire.</li>
</ul>
<h2>Pratiquer avec CesiZen</h2>
<p>L''application CesiZen propose des configurations de respiration guidée (visuelle et sonore) calquées sur la cohérence cardiaque. Lancez une session de 5 minutes avant chaque moment de stress identifié.</p>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_crise, 'Respiration en situation de crise', 'Techniques de respiration rapides pour les moments d''urgence émotionnelle.',
'<h2>Quand on est submergé</h2>
<p>En situation de crise (anxiété intense, colère, panique), la respiration s''emballe. Reprendre le contrôle de sa respiration est le levier le plus rapide pour interrompre la spirale.</p>
<h2>Technique 1 : Expiration prolongée</h2>
<p>Inspirez 4 secondes par le nez, expirez 6 à 8 secondes par la bouche. L''expiration plus longue active le nerf vague et le frein vagal cardiaque en moins de 30 secondes.</p>
<h2>Technique 2 : Respiration physiologique (soupir)</h2>
<p>Prenez une grande inspiration, puis une petite inspiration supplémentaire pour maximiser le remplissage pulmonaire, puis expirez lentement tout l''air. Répétez 2 à 3 fois. Scientifiquement validé par Stanford comme le moyen le plus rapide de réduire le stress aigu.</p>
<h2>Technique 3 : Respiration carrée</h2>
<p>4s inspiration → 4s rétention → 4s expiration → 4s rétention. Utilisée par les Navy SEALs pour rester calmes sous pression extrême.</p>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- Catégorie Sommeil
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_sommeil_cycles, 'Les cycles du sommeil', 'Comprendre l''architecture du sommeil pour mieux récupérer.',
'<h2>Structure d''une nuit de sommeil</h2>
<p>Le sommeil se déroule en cycles de 90 minutes environ, répétés 4 à 6 fois par nuit. Chaque cycle comprend :</p>
<ul>
  <li><strong>Sommeil léger (N1-N2) :</strong> transition entre veille et sommeil profond.</li>
  <li><strong>Sommeil profond (N3) :</strong> récupération physique, consolidation immunitaire.</li>
  <li><strong>Sommeil paradoxal (REM) :</strong> rêves, consolidation mémorielle, récupération cognitive.</li>
</ul>
<h2>Pourquoi se lever à la fin d''un cycle ?</h2>
<p>Se réveiller en milieu de sommeil profond provoque une inertie du sommeil (grogginess). En calculant ses cycles (multiples de 90 min + 15 min d''endormissement), on optimise la fraîcheur au réveil.</p>
<h2>Les ennemis du sommeil profond</h2>
<ul>
  <li>Alcool (perturbe le REM).</li>
  <li>Température > 19°C.</li>
  <li>Lumière bleue dans l''heure précédant le coucher.</li>
  <li>Repas copieux tardifs.</li>
</ul>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_sommeil_stress, 'Stress et sommeil : le cercle vicieux', 'Comment le stress perturbe le sommeil et comment briser ce cycle.',
'<h2>Le lien bidirectionnel</h2>
<p>Le stress perturbe le sommeil, et le manque de sommeil augmente la réactivité au stress. Ce cercle vicieux est l''un des facteurs les plus fréquents dans les troubles anxieux et le burnout.</p>
<h2>Ce qui se passe la nuit quand on est stressé</h2>
<ul>
  <li>Le cortisol reste élevé → difficulté à s''endormir.</li>
  <li>Le sommeil profond est réduit → récupération incomplète.</li>
  <li>Le REM est fragmenté → consolidation émotionnelle altérée.</li>
</ul>
<h2>Briser le cycle</h2>
<h3>Rituel pré-sommeil</h3>
<ol>
  <li>1h avant : extinction des écrans.</li>
  <li>30 min avant : lecture légère ou étirements doux.</li>
  <li>15 min avant : cohérence cardiaque (5 min) + scan corporel.</li>
</ol>
<h3>En cas de réveil nocturne</h3>
<p>Ne restez pas dans le lit à ruminer plus de 20 minutes. Levez-vous, lisez sous une lumière tamisée, puis revenez au lit quand la somnolence revient.</p>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- Catégorie Pleine conscience
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_mind_intro, 'Introduction à la pleine conscience', 'Qu''est-ce que le mindfulness et pourquoi le pratiquer ?',
'<h2>Définition</h2>
<p>La pleine conscience (mindfulness) est la capacité à porter son attention sur le moment présent, de façon intentionnelle et sans jugement. Popularisée en Occident par Jon Kabat-Zinn, elle est aujourd''hui utilisée en médecine, psychologie et entreprise.</p>
<h2>Les bénéfices validés</h2>
<ul>
  <li>Réduction de l''anxiété et des symptômes dépressifs.</li>
  <li>Meilleure gestion de la douleur chronique.</li>
  <li>Augmentation de l''attention et de la concentration.</li>
  <li>Développement de la résilience émotionnelle.</li>
</ul>
<h2>Méditation de la respiration — 5 minutes</h2>
<ol>
  <li>Asseyez-vous, dos droit, yeux fermés.</li>
  <li>Portez l''attention sur les sensations de la respiration.</li>
  <li>Quand l''esprit s''égare, ramenez-le doucement — sans jugement.</li>
  <li>Répétez pendant 5 minutes.</li>
</ol>
<p>La régularité prime sur la durée : 5 minutes chaque jour valent mieux qu''1h le week-end.</p>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_mind_quotidien, 'Pleine conscience au quotidien', 'Intégrer le mindfulness dans les activités de tous les jours.',
'<h2>Le piège du pilote automatique</h2>
<p>Nous passons une grande partie de notre journée en mode "automatique" — mangeons sans goûter, marchons sans voir, parlons sans écouter. La pleine conscience propose de sortir de ce mode.</p>
<h2>Exercices du quotidien</h2>
<h3>La pleine conscience en mangeant</h3>
<p>Mangez un repas par jour sans écran. Observez les couleurs, les textures, les saveurs. Posez la fourchette entre chaque bouchée. Ce simple exercice réduit le grignotage émotionnel.</p>
<h3>La marche consciente</h3>
<p>Lors d''un trajet à pied, portez attention à chaque pas, au contact du sol, au mouvement des bras, aux sons autour de vous. 10 minutes suffisent à recentrer l''esprit.</p>
<h3>La pause de 3 minutes</h3>
<p>3 fois par jour, arrêtez-vous 3 minutes : 1 minute pour observer vos pensées, 1 minute pour vous concentrer sur votre respiration, 1 minute pour élargir la conscience à votre corps entier.</p>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- Catégorie Énergie
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES
    (p_energie_alim, 'Alimentation et énergie mentale', 'Comment ce que vous mangez influence votre humeur et votre niveau de stress.',
'<h2>Le cerveau, grand consommateur d''énergie</h2>
<p>Le cerveau représente 2 % de notre masse corporelle mais consomme 20 % de notre énergie. La qualité de notre alimentation influence directement nos capacités cognitives, notre humeur et notre résistance au stress.</p>
<h2>Les aliments pro-sérénité</h2>
<ul>
  <li><strong>Oméga-3</strong> (poissons gras, noix, lin) : réduisent l''inflammation et soutiennent la santé cérébrale.</li>
  <li><strong>Magnésium</strong> (légumineuses, amandes, chocolat noir) : régulateur clé du système nerveux.</li>
  <li><strong>Tryptophane</strong> (œufs, banane, dinde) : précurseur de la sérotonine.</li>
</ul>
<h2>Ce qu''il faut limiter</h2>
<ul>
  <li>Sucres rapides (pics glycémiques → fatigue et irritabilité).</li>
  <li>Caféine excessive (amplifie la réponse au stress).</li>
  <li>Alcool (perturbateur du sommeil et anxiogène à long terme).</li>
</ul>',
'html', false, 'published', true, NOW(), v_admin_id),

    (p_energie_hydrat, 'Hydratation et concentration', 'L''impact souvent sous-estimé de l''hydratation sur les capacités mentales.',
'<h2>La déshydratation, ennemi discret</h2>
<p>Une déshydratation de seulement 1 à 2 % du poids corporel suffit à réduire les performances cognitives, augmenter la fatigue et dégrader l''humeur. Pourtant, la plupart des adultes boivent insuffisamment.</p>
<h2>Besoins quotidiens</h2>
<p>1,5 à 2 litres d''eau par jour en conditions normales, davantage par temps chaud ou lors d''effort physique. Les tisanes, soupes et fruits hydratants comptent.</p>
<h2>Stratégies pour boire plus</h2>
<ul>
  <li>Commencer la journée par un grand verre d''eau à jeun.</li>
  <li>Avoir toujours une bouteille visible sur son bureau.</li>
  <li>Associer l''hydratation à des moments clés (avant chaque réunion, après chaque pause).</li>
</ul>
<h2>Hydratation et stress</h2>
<p>Le cortisol réduit la capacité des reins à retenir l''eau. Les personnes stressées se déshydratent plus vite — et la déshydratation amplifie la réponse au stress. Un autre cercle vicieux à briser.</p>',
'html', false, 'published', true, NOW(), v_admin_id);

    -- ===========================================================
    -- TAGGED — relations pages <-> tags (le coeur du graphe)
    -- ===========================================================
    INSERT INTO tagged (id, id_information_tags) VALUES
        -- Stress
        (p_stress_comprendre, tag_stress),
        (p_stress_comprendre, tag_bien_etre),
        (p_stress_burnout,    tag_stress),
        (p_stress_burnout,    tag_anxiete),
        (p_stress_burnout,    tag_bien_etre),
        (p_stress_travail,    tag_stress),
        (p_stress_travail,    tag_bien_etre),
        (p_stress_travail,    tag_respiration),
        -- Anxiété
        (p_anxiete_crises,    tag_anxiete),
        (p_anxiete_crises,    tag_stress),
        (p_anxiete_crises,    tag_respiration),
        (p_anxiete_tcc,       tag_anxiete),
        (p_anxiete_tcc,       tag_bien_etre),
        -- Respiration
        (p_resp_bases,        tag_respiration),
        (p_resp_bases,        tag_bien_etre),
        (p_resp_coh,          tag_respiration),
        (p_resp_coh,          tag_coh_card),
        (p_resp_coh,          tag_stress),
        (p_resp_crise,        tag_respiration),
        (p_resp_crise,        tag_anxiete),
        (p_resp_crise,        tag_coh_card),
        -- Sommeil
        (p_sommeil_cycles,    tag_sommeil),
        (p_sommeil_cycles,    tag_bien_etre),
        (p_sommeil_stress,    tag_sommeil),
        (p_sommeil_stress,    tag_stress),
        (p_sommeil_stress,    tag_anxiete),
        -- Pleine conscience
        (p_mind_intro,        tag_mindfulness),
        (p_mind_intro,        tag_bien_etre),
        (p_mind_intro,        tag_anxiete),
        (p_mind_quotidien,    tag_mindfulness),
        (p_mind_quotidien,    tag_bien_etre),
        (p_mind_quotidien,    tag_stress),
        -- Énergie
        (p_energie_alim,      tag_energie),
        (p_energie_alim,      tag_bien_etre),
        (p_energie_hydrat,    tag_energie),
        (p_energie_hydrat,    tag_stress)
    ON CONFLICT DO NOTHING;

    -- ===========================================================
    -- NAVIGATION MENU — hiérarchie simulée par label et URL
    -- pos 1 = entrée principale, pos N = sous-entrée (label indenté)
    -- ===========================================================
    INSERT INTO navigation_menu (id, position, label, url, currently_editing, creation_time) VALUES
        (m_home,       1,  'Accueil',                       '/',                                   false, NOW()),

        -- Santé mentale
        (m_sante_h,    2,  'Santé mentale',                 '/sante-mentale',                      false, NOW()),
        (m_stress,     3,  '— Comprendre le stress',        '/sante-mentale/stress',               false, NOW()),
        (m_burnout,    4,  '— Reconnaître le burnout',      '/sante-mentale/burnout',              false, NOW()),
        (m_anxiete,    5,  '— Gérer son anxiété',           '/sante-mentale/anxiete',              false, NOW()),
        (m_tcc,        6,  '— Thérapie cognitive (TCC)',     '/sante-mentale/tcc',                  false, NOW()),

        -- Respiration
        (m_resp_h,     7,  'Respiration',                   '/respiration',                        false, NOW()),
        (m_resp_bases, 8,  '— Les bases',                   '/respiration/bases',                  false, NOW()),
        (m_resp_coh,   9,  '— Cohérence cardiaque',         '/respiration/coherence-cardiaque',    false, NOW()),
        (m_resp_crise, 10, '— En situation de crise',       '/respiration/crise',                  false, NOW()),

        -- Sommeil
        (m_sommeil_h,  11, 'Sommeil',                       '/sommeil',                            false, NOW()),
        (m_sommeil,    12, '— Les cycles du sommeil',       '/sommeil/cycles',                     false, NOW()),
        (m_som_stress, 13, '— Stress et sommeil',           '/sommeil/stress',                     false, NOW()),

        -- Pleine conscience
        (m_mind_h,     14, 'Pleine conscience',             '/pleine-conscience',                  false, NOW()),
        (m_mind_intro, 15, '— Introduction',                '/pleine-conscience/introduction',     false, NOW()),
        (m_mind_quot,  16, '— Au quotidien',                '/pleine-conscience/quotidien',        false, NOW()),

        -- Énergie
        (m_energie_h,  17, 'Énergie & Nutrition',           '/energie',                            false, NOW()),
        (m_alim,       18, '— Alimentation & humeur',       '/energie/alimentation',               false, NOW()),
        (m_hydrat,     19, '— Hydratation',                 '/energie/hydratation',                false, NOW())
    ON CONFLICT DO NOTHING;

    -- ===========================================================
    -- QUIZZES
    -- ===========================================================
    INSERT INTO quizz (id, nom, active, creation_time) VALUES
        (q1, 'Évaluation de mon niveau de stress',           true, NOW()),
        (q2, 'Qualité de mon sommeil',                       true, NOW()),
        (q3, 'Niveau d''anxiété (GAD-7 adapté)',             true, NOW()),
        (q4, 'Mon profil de respiration',                    true, NOW()),
        (q5, 'Bilan de bien-être général',                   true, NOW());

    -- QUIZ 1 : Stress
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Au cours des 2 dernières semaines, à quelle fréquence avez-vous eu du mal à vous détendre ?', 1, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',             1, 'stress_level', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Rarement',           2, 'stress_level', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Parfois',            3, 'stress_level', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Souvent',            4, 'stress_level', 'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Presque toujours',   5, 'stress_level', 'add', '4', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous des tensions physiques liées au stress (nuque, épaules, mâchoires) ?', 2, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Non, aucune',                      1, 'physical_tension', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Légères et passagères',            2, 'physical_tension', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Modérées, quelques fois/semaine',  3, 'physical_tension', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Importantes et fréquentes',        4, 'physical_tension', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment évaluez-vous votre charge de travail actuelle ?', 3, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Gérable et équilibrée',        1, 'workload', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Un peu chargée',               2, 'workload', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Très chargée',                 3, 'workload', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Totalement débordant(e)',      4, 'workload', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Votre sommeil est-il perturbé par des pensées stressantes ?', 4, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Non, je dors bien',                      1, 'sleep_stress', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Parfois, mais je me rendors facilement', 2, 'sleep_stress', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Souvent, j''ai du mal à m''endormir',   3, 'sleep_stress', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Toutes les nuits, très perturbé(e)',     4, 'sleep_stress', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Pratiquez-vous une activité de relaxation régulière ?', 5, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, régulièrement',       1, 'coping', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'De temps en temps',        2, 'coping', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Rarement',                 3, 'coping', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Non, jamais',              4, 'coping', 'add', '3', NOW(), qq);
    END;

    -- QUIZ 2 : Sommeil
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Combien de temps vous faut-il pour vous endormir ?', 1, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Moins de 10 minutes',    1, 'sleep_latency', 'add', '0', NOW(), qq),
        (gen_random_uuid(), '10 à 20 minutes',        2, 'sleep_latency', 'add', '1', NOW(), qq),
        (gen_random_uuid(), '20 à 30 minutes',        3, 'sleep_latency', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Plus de 30 minutes',     4, 'sleep_latency', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Combien d''heures dormez-vous en moyenne par nuit ?', 2, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), '8h ou plus',         1, 'sleep_duration', 'add', '0', NOW(), qq),
        (gen_random_uuid(), '7 à 8h',             2, 'sleep_duration', 'add', '0', NOW(), qq),
        (gen_random_uuid(), '6 à 7h',             3, 'sleep_duration', 'add', '1', NOW(), qq),
        (gen_random_uuid(), '5 à 6h',             4, 'sleep_duration', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Moins de 5h',        5, 'sleep_duration', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Vous réveillez-vous pendant la nuit ?', 3, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Non, je dors d''une traite',        1, 'night_waking', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Rarement (1x/semaine)',             2, 'night_waking', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Parfois (2-3x/semaine)',            3, 'night_waking', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Souvent (presque chaque nuit)',     4, 'night_waking', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment vous sentez-vous au réveil ?', 4, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Reposé(e) et énergique',               1, 'morning_feeling', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plutôt bien, légèrement fatigué(e)',   2, 'morning_feeling', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Fatigué(e), besoin de temps',          3, 'morning_feeling', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Épuisé(e), comme si je n''avais pas dormi', 4, 'morning_feeling', 'add', '3', NOW(), qq);
    END;

    -- QUIZ 3 : Anxiété GAD-7
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Vous êtes-vous senti(e) nerveux(se) ou très tendu(e) ?', 1, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',                    1, 'anxiety_score', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plusieurs jours',           2, 'anxiety_score', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plus de la moitié du temps', 3, 'anxiety_score', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Presque tous les jours',    4, 'anxiety_score', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Êtes-vous incapable de contrôler vos inquiétudes ?', 2, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',                    1, 'anxiety_score', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plusieurs jours',           2, 'anxiety_score', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plus de la moitié du temps', 3, 'anxiety_score', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Presque tous les jours',    4, 'anxiety_score', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous du mal à vous concentrer à cause de l''inquiétude ?', 3, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',                    1, 'anxiety_score', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plusieurs jours',           2, 'anxiety_score', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plus de la moitié du temps', 3, 'anxiety_score', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Presque tous les jours',    4, 'anxiety_score', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Vous sentez-vous agité(e) au point de ne pas pouvoir rester assis(e) ?', 4, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',                    1, 'anxiety_score', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plusieurs jours',           2, 'anxiety_score', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plus de la moitié du temps', 3, 'anxiety_score', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Presque tous les jours',    4, 'anxiety_score', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous peur qu''il vous arrive quelque chose de terrible ?', 5, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Jamais',                    1, 'anxiety_score', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Plusieurs jours',           2, 'anxiety_score', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plus de la moitié du temps', 3, 'anxiety_score', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Presque tous les jours',    4, 'anxiety_score', 'add', '3', NOW(), qq);
    END;

    -- QUIZ 4 : Profil respiration
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment décririez-vous votre respiration au repos ?', 1, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Lente et profonde, abdominale',          1, 'breathing_profile', 'set', 'deep',      NOW(), qq),
        (gen_random_uuid(), 'Régulière, ni trop rapide ni lente',     2, 'breathing_profile', 'set', 'normal',    NOW(), qq),
        (gen_random_uuid(), 'Rapide et thoracique',                   3, 'breathing_profile', 'set', 'shallow',   NOW(), qq),
        (gen_random_uuid(), 'Irrégulière, j''oublie de respirer',     4, 'breathing_profile', 'set', 'irregular', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quel est votre principal objectif avec la respiration guidée ?', 2, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Réduire mon stress et mon anxiété',  1, 'objective', 'set', 'stress',  NOW(), qq),
        (gen_random_uuid(), 'Améliorer mon sommeil',              2, 'objective', 'set', 'sleep',   NOW(), qq),
        (gen_random_uuid(), 'Améliorer ma concentration',         3, 'objective', 'set', 'focus',   NOW(), qq),
        (gen_random_uuid(), 'Booster mon énergie',                4, 'objective', 'set', 'energy',  NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Combien de temps pouvez-vous consacrer à un exercice ?', 3, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Moins de 3 minutes',    1, 'duration_pref', 'set', 'short',    NOW(), qq),
        (gen_random_uuid(), '3 à 5 minutes',         2, 'duration_pref', 'set', 'medium',   NOW(), qq),
        (gen_random_uuid(), '5 à 10 minutes',        3, 'duration_pref', 'set', 'long',     NOW(), qq),
        (gen_random_uuid(), 'Plus de 10 minutes',    4, 'duration_pref', 'set', 'extended', NOW(), qq);
    END;

    -- QUIZ 5 : Bien-être général
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment évaluez-vous votre niveau d''énergie global ?', 1, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Très élevé, je me sens en forme',     1, 'energy', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Bon',                                 2, 'energy', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Moyen, manque d''énergie parfois',    3, 'energy', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Faible, souvent épuisé(e)',           4, 'energy', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quelle est votre humeur générale ces derniers jours ?', 2, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Positive et enthousiaste',          1, 'mood', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Équilibrée',                        2, 'mood', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Plutôt maussade',                   3, 'mood', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Triste ou irritable',               4, 'mood', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Pratiquez-vous une activité physique régulière ?', 3, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, +3 fois/semaine',     1, 'physical_activity', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Oui, 1-2 fois/semaine',    2, 'physical_activity', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Rarement',                 3, 'physical_activity', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Non, jamais',              4, 'physical_activity', 'add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous des moments de détente dans votre journée ?', 4, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, chaque jour',                     1, 'relaxation', 'add', '0', NOW(), qq),
        (gen_random_uuid(), 'Parfois',                              2, 'relaxation', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Rarement',                             3, 'relaxation', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Non, pas le temps',                    4, 'relaxation', 'add', '3', NOW(), qq);
    END;

    RAISE NOTICE 'Seed completed successfully.';
END $$;
