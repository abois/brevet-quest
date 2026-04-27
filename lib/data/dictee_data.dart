/// Une phrase de dictée — `id` correspond au nom du fichier MP3.
class DicteeItem {
  const DicteeItem({required this.id, required this.text});

  final String id;
  final String text;

  /// Chemin de l'asset audio généré par `tools/generate_dictee.py`.
  String get assetPath => 'audio/dictee/$id.mp3';
}

/// Catalogue de dictées brevet — doit rester aligné avec
/// `tools/dictee_catalog.json` (mêmes ids).
class DicteeData {
  const DicteeData._();

  static const List<DicteeItem> all = <DicteeItem>[
    DicteeItem(
      id: 'd01',
      text: 'Le millénaire a apporté de nombreux changements.',
    ),
    DicteeItem(
      id: 'd02',
      text: 'Il faut que tu sois là à l\'heure.',
    ),
    DicteeItem(
      id: 'd03',
      text: 'Les enfants qu\'elle a vus jouaient dans le jardin.',
    ),
    DicteeItem(
      id: 'd04',
      text: 'C\'est quand même surprenant qu\'il ait abandonné.',
    ),
    DicteeItem(
      id: 'd05',
      text: 'Quel courage ! Elle n\'a pas hésité une seconde.',
    ),
    DicteeItem(
      id: 'd06',
      text: 'Ils se sont parlé toute la soirée.',
    ),
    DicteeItem(
      id: 'd07',
      text: 'La petite fille avait peur du tonnerre.',
    ),
    DicteeItem(
      id: 'd08',
      text: 'Nous avons appelé nos amis pour les inviter.',
    ),
    DicteeItem(
      id: 'd09',
      text: 'Cette histoire ressemble à un conte de fées.',
    ),
    DicteeItem(
      id: 'd10',
      text: 'Le voyageur traverse de magnifiques paysages.',
    ),
    DicteeItem(
      id: 'd11',
      text: 'Elle s\'est rappelé tous les détails de l\'événement.',
    ),
    DicteeItem(
      id: 'd12',
      text: 'On dirait qu\'il pleut à verse depuis ce matin.',
    ),
    DicteeItem(
      id: 'd13',
      text: 'Les pommes que j\'ai mangées étaient délicieuses.',
    ),
    DicteeItem(
      id: 'd14',
      text: 'Aussitôt qu\'il aura terminé, il viendra nous voir.',
    ),
    DicteeItem(
      id: 'd15',
      text: 'Bien que fatigués, ils ont continué la randonnée.',
    ),
    DicteeItem(
      id: 'd16',
      text: 'Le chercheur a découvert une espèce inconnue.',
    ),
    DicteeItem(
      id: 'd17',
      text: 'Si j\'avais su, je serais resté à la maison.',
    ),
    DicteeItem(
      id: 'd18',
      text: 'Les fleurs jaunes embellissent le balcon.',
    ),
    DicteeItem(
      id: 'd19',
      text: 'Quelle quantité d\'eau as-tu bue ce matin ?',
    ),
    DicteeItem(
      id: 'd20',
      text: 'Personne ne savait quelle décision prendre.',
    ),
    DicteeItem(
      id: 'd21',
      text: 'Le philosophe défendait une thèse audacieuse.',
    ),
    DicteeItem(
      id: 'd22',
      text: 'Elles se sont préparées sans se plaindre.',
    ),
    DicteeItem(
      id: 'd23',
      text: 'Tout à coup, un éclair illumina le ciel.',
    ),
    DicteeItem(
      id: 'd24',
      text: 'Il est nécessaire que vous ayez confiance en vous.',
    ),
    DicteeItem(
      id: 'd25',
      text: 'L\'œuvre de cet écrivain est intemporelle.',
    ),
    DicteeItem(
      id: 'd26',
      text: 'Mon père m\'a offert un magnifique stylo plume.',
    ),
    DicteeItem(
      id: 'd27',
      text: 'À chaque instant, elle observait les nuages.',
    ),
    DicteeItem(
      id: 'd28',
      text: 'Les chevaux galopaient dans la prairie verte.',
    ),
    DicteeItem(
      id: 'd29',
      text: 'Bien qu\'il fût tard, ils refusèrent de partir.',
    ),
    DicteeItem(
      id: 'd30',
      text: 'Le gardien a rangé les ballons dans le placard.',
    ),
  ];
}
