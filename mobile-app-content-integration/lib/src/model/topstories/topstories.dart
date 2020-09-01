// To parse this JSON data, do
//
//     final topStories = topStoriesFromJson(jsonString);

import 'dart:convert';

TopStories topStoriesFromJson(String str) => TopStories.fromJson(json.decode(str));

String topStoriesToJson(TopStories data) => json.encode(data.toJson());

class TopStories {
    TopStories({
        this.type,
        this.id,
        this.attributes,
        this.links,
        this.meta,
    });

    String type;
    String id;
    Attributes attributes;
    Links links;
    Meta meta;

    factory TopStories.fromJson(Map<String, dynamic> json) => TopStories(
        type: json['type'],
        id: json['id'],
        attributes: Attributes.fromJson(json['attributes']),
        links: Links.fromJson(json['links']),
        meta: Meta.fromJson(json['meta']),
    );

    Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'attributes': attributes.toJson(),
        'links': links.toJson(),
        'meta': meta.toJson(),
    };
}

class Attributes {
    Attributes({
        this.associations,
        this.authors,
        this.body,
        this.byline,
        this.columnName,
        this.copyright,
        this.headline,
        this.hostedUrl,
        this.contentResources,
        this.liveDate,
        this.liveTime,
        this.majorRevisionDate,
        this.minorRevision,
        this.modificationDate,
        this.modificationTime,
        this.originalHeadline,
        this.page,
        this.product,
        this.publicationDate,
        this.publicationTime,
        this.publisher,
        this.sectionName,
        this.sectionType,
        this.seoId,
        this.summary,
    });

    Associations associations;
    List<Author> authors;
    List<AttributesBody> body;
    Byline byline;
    String columnName;
    Copyright copyright;
    AttributesHeadline headline;
    String hostedUrl;
    List<ContentResource> contentResources;
    String liveDate;
    DateTime liveTime;
    DateTime majorRevisionDate;
    bool minorRevision;
    String modificationDate;
    DateTime modificationTime;
    Copyright originalHeadline;
    String page;
    String product;
    String publicationDate;
    DateTime publicationTime;
    Publisher publisher;
    Copyright sectionName;
    String sectionType;
    String seoId;
    Summary summary;

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        associations: Associations.fromJson(json['associations']),
        authors: List<Author>.from(json['authors'].map((x) => Author.fromJson(x))),
        body: List<AttributesBody>.from(json['body'].map((x) => AttributesBody.fromJson(x))),
        byline: Byline.fromJson(json['byline']),
        columnName: json['column_name'],
        copyright: Copyright.fromJson(json['copyright']),
        headline: AttributesHeadline.fromJson(json['headline']),
        hostedUrl: json['hosted_url'],
        contentResources: List<ContentResource>.from(json['content_resources'].map((x) => ContentResource.fromJson(x))),
        liveDate: json['live_date'],
        liveTime: DateTime.parse(json['live_time']),
        majorRevisionDate: DateTime.parse(json['major_revision_date']),
        minorRevision: json['minor_revision'],
        modificationDate: json['modification_date'],
        modificationTime: DateTime.parse(json['modification_time']),
        originalHeadline: Copyright.fromJson(json['original_headline']),
        page: json['page'],
        product: json['product'],
        publicationDate: json['publication_date'],
        publicationTime: DateTime.parse(json['publication_time']),
        publisher: Publisher.fromJson(json['publisher']),
        sectionName: Copyright.fromJson(json['section_name']),
        sectionType: json['section_type'],
        seoId: json['seo_id'],
        summary: Summary.fromJson(json['summary']),
    );

    Map<String, dynamic> toJson() => {
        'associations': associations.toJson(),
        'authors': List<dynamic>.from(authors.map((x) => x.toJson())),
        'body': List<dynamic>.from(body.map((x) => x.toJson())),
        'byline': byline.toJson(),
        'column_name': columnName,
        'copyright': copyright.toJson(),
        'headline': headline.toJson(),
        'hosted_url': hostedUrl,
        'content_resources': List<dynamic>.from(contentResources.map((x) => x.toJson())),
        'live_date': liveDate,
        'live_time': liveTime.toIso8601String(),
        'major_revision_date': majorRevisionDate.toIso8601String(),
        'minor_revision': minorRevision,
        'modification_date': modificationDate,
        'modification_time': modificationTime.toIso8601String(),
        'original_headline': originalHeadline.toJson(),
        'page': page,
        'product': product,
        'publication_date': publicationDate,
        'publication_time': publicationTime.toIso8601String(),
        'publisher': publisher.toJson(),
        'section_name': sectionName.toJson(),
        'section_type': sectionType,
        'seo_id': seoId,
        'summary': summary.toJson(),
    };
}

class Associations {
    Associations({
        this.rootId,
    });

    String rootId;

    factory Associations.fromJson(Map<String, dynamic> json) => Associations(
        rootId: json['root_id'],
    );

    Map<String, dynamic> toJson() => {
        'root_id': rootId,
    };
}

class Author {
    Author({
        this.fullName,
        this.topicId,
    });

    String fullName;
    String topicId;

    factory Author.fromJson(Map<String, dynamic> json) => Author(
        fullName: json['full_name'],
        topicId: json['topic_id'],
    );

    Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'topic_id': topicId,
    };
}

class AttributesBody {
    AttributesBody({
        this.type,
        this.ref,
        this.display,
        this.content,
    });

    BodyType type;
    String ref;
    Display display;
    List<BodyContent> content;

    factory AttributesBody.fromJson(Map<String, dynamic> json) => AttributesBody(
        type: bodyTypeValues.map[json['type']],
        ref: json['ref'],
        display: json['display'] == null ? null : displayValues.map[json['display']],
        content: json['content'] == null ? null : List<BodyContent>.from(json['content'].map((x) => BodyContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'type': bodyTypeValues.reverse[type],
        'ref': ref,
        'display': display == null ? null : displayValues.reverse[display],
        'content': content == null ? null : List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class BodyContent {
    BodyContent({
        this.type,
        this.entityType,
        this.significance,
        this.ref,
        this.text,
        this.icon,
        this.linkType,
        this.emphasisType,
    });

    ContentType type;
    String entityType;
    String significance;
    String ref;
    String text;
    String icon;
    String linkType;
    String emphasisType;

    factory BodyContent.fromJson(Map<String, dynamic> json) => BodyContent(
        type: json['type'] == null ? null : contentTypeValues.map[json['type']],
        entityType: json['entity_type'],
        significance: json['significance'],
        ref: json['ref'],
        text: json['text'],
        icon: json['icon'],
        linkType: json['link_type'],
        emphasisType: json['emphasis_type'],
    );

    Map<String, dynamic> toJson() => {
        'type': type == null ? null : contentTypeValues.reverse[type],
        'entity_type': entityType,
        'significance': significance,
        'ref': ref,
        'text': text,
        'icon': icon,
        'link_type': linkType,
        'emphasis_type': emphasisType,
    };
}

enum ContentType { ENTITY, LINK, EMPHASIS }

final contentTypeValues = EnumValues({
    'Emphasis': ContentType.EMPHASIS,
    'Entity': ContentType.ENTITY,
    'Link': ContentType.LINK
});

enum Display { PLAIN }

final displayValues = EnumValues({
    'Plain': Display.PLAIN
});

enum BodyType { IMAGE, PARAGRAPH }

final bodyTypeValues = EnumValues({
    'Image': BodyType.IMAGE,
    'Paragraph': BodyType.PARAGRAPH
});

class Byline {
    Byline({
        this.content,
    });

    List<BylineContent> content;

    factory Byline.fromJson(Map<String, dynamic> json) => Byline(
        content: List<BylineContent>.from(json['content'].map((x) => BylineContent.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'content': List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class BylineContent {
    BylineContent({
        this.text,
        this.type,
        this.entityType,
        this.ref,
    });

    String text;
    ContentType type;
    String entityType;
    String ref;

    factory BylineContent.fromJson(Map<String, dynamic> json) => BylineContent(
        text: json['text'],
        type: json['type'] == null ? null : contentTypeValues.map[json['type']],
        entityType: json['entity_type'],
        ref: json['ref'],
    );

    Map<String, dynamic> toJson() => {
        'text': text,
        'type': type == null ? null : contentTypeValues.reverse[type],
        'entity_type': entityType,
        'ref': ref,
    };
}

class ContentResource {
    ContentResource({
        this.name,
        this.id,
        this.type,
        this.significance,
        this.firstName,
        this.lastName,
        this.confidence,
        this.nameFormat,
        this.variant,
        this.uri,
        this.mediaType,
        this.slug,
        this.width,
        this.height,
        this.sizeCode,
        this.alternateText,
        this.credit,
        this.altImages,
        this.properties,
        this.caption,
    });

    String name;
    String id;
    String type;
    String significance;
    String firstName;
    String lastName;
    int confidence;
    String nameFormat;
    String variant;
    String uri;
    String mediaType;
    String slug;
    int width;
    int height;
    String sizeCode;
    String alternateText;
    String credit;
    List<AltImage> altImages;
    ContentResourceProperties properties;
    String caption;

    factory ContentResource.fromJson(Map<String, dynamic> json) => ContentResource(
        name: json['name'],
        id: json['id'],
        type: json['type'],
        significance: json['significance'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        confidence: json['confidence'],
        nameFormat: json['name_format'],
        variant: json['variant'],
        uri: json['uri'],
        mediaType: json['media_type'],
        slug: json['slug'],
        width: json['width'],
        height: json['height'],
        sizeCode: json['size_code'],
        alternateText: json['alternate_text'],
        credit: json['credit'],
        altImages: json['alt_images'] == null ? null : List<AltImage>.from(json['alt_images'].map((x) => AltImage.fromJson(x))),
        properties: json['properties'] == null ? null : ContentResourceProperties.fromJson(json['properties']),
        caption: json['caption'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'type': type,
        'significance': significance,
        'first_name': firstName,
        'last_name': lastName,
        'confidence': confidence,
        'name_format': nameFormat,
        'variant': variant,
        'uri': uri,
        'media_type': mediaType,
        'slug': slug,
        'width': width,
        'height': height,
        'size_code': sizeCode,
        'alternate_text': alternateText,
        'credit': credit,
        'alt_images': altImages == null ? null : List<dynamic>.from(altImages.map((x) => x.toJson())),
        'properties': properties == null ? null : properties.toJson(),
        'caption': caption,
    };
}

class AltImage {
    AltImage({
        this.name,
        this.width,
        this.height,
        this.sizeCode,
        this.url,
    });

    String name;
    int width;
    int height;
    String sizeCode;
    String url;

    factory AltImage.fromJson(Map<String, dynamic> json) => AltImage(
        name: json['name'],
        width: json['width'],
        height: json['height'],
        sizeCode: json['size_code'],
        url: json['url'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'width': width,
        'height': height,
        'size_code': sizeCode,
        'url': url,
    };
}

class ContentResourceProperties {
    ContentResourceProperties({
        this.softcrop,
        this.location,
        this.imphotoid,
        this.responsive,
    });

    String softcrop;
    String location;
    String imphotoid;
    Responsive responsive;

    factory ContentResourceProperties.fromJson(Map<String, dynamic> json) => ContentResourceProperties(
        softcrop: json['softcrop'],
        location: json['location'],
        imphotoid: json['imphotoid'],
        responsive: json['responsive'] == null ? null : Responsive.fromJson(json['responsive']),
    );

    Map<String, dynamic> toJson() => {
        'softcrop': softcrop,
        'location': location,
        'imphotoid': imphotoid,
        'responsive': responsive == null ? null : responsive.toJson(),
    };
}

class Responsive {
    Responsive({
        this.layout,
    });

    String layout;

    factory Responsive.fromJson(Map<String, dynamic> json) => Responsive(
        layout: json['layout'],
    );

    Map<String, dynamic> toJson() => {
        'layout': layout,
    };
}

class Copyright {
    Copyright({
        this.text,
    });

    String text;

    factory Copyright.fromJson(Map<String, dynamic> json) => Copyright(
        text: json['text'],
    );

    Map<String, dynamic> toJson() => {
        'text': text,
    };
}

class AttributesHeadline {
    AttributesHeadline({
        this.main,
        this.deck,
    });

    Copyright main;
    Deck deck;

    factory AttributesHeadline.fromJson(Map<String, dynamic> json) => AttributesHeadline(
        main: Copyright.fromJson(json['main']),
        deck: Deck.fromJson(json['deck']),
    );

    Map<String, dynamic> toJson() => {
        'main': main.toJson(),
        'deck': deck.toJson(),
    };
}

class Deck {
    Deck({
        this.type,
        this.content,
    });

    String type;
    List<Copyright> content;

    factory Deck.fromJson(Map<String, dynamic> json) => Deck(
        type: json['type'],
        content: List<Copyright>.from(json['content'].map((x) => Copyright.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'type': type,
        'content': List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class Publisher {
    Publisher({
        this.name,
    });

    String name;

    factory Publisher.fromJson(Map<String, dynamic> json) => Publisher(
        name: json['name'],
    );

    Map<String, dynamic> toJson() => {
        'name': name,
    };
}

class Summary {
    Summary({
        this.headline,
        this.body,
    });

    SummaryHeadline headline;
    List<SummaryBody> body;

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        headline: SummaryHeadline.fromJson(json['headline']),
        body: List<SummaryBody>.from(json['body'].map((x) => SummaryBody.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'headline': headline.toJson(),
        'body': List<dynamic>.from(body.map((x) => x.toJson())),
    };
}

class SummaryBody {
    SummaryBody({
        this.type,
        this.ref,
        this.content,
    });

    String type;
    String ref;
    List<Copyright> content;

    factory SummaryBody.fromJson(Map<String, dynamic> json) => SummaryBody(
        type: json['type'],
        ref: json['ref'],
        content: json['content'] == null ? null : List<Copyright>.from(json['content'].map((x) => Copyright.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'type': type,
        'ref': ref,
        'content': content == null ? null : List<dynamic>.from(content.map((x) => x.toJson())),
    };
}

class SummaryHeadline {
    SummaryHeadline({
        this.main,
    });

    Deck main;

    factory SummaryHeadline.fromJson(Map<String, dynamic> json) => SummaryHeadline(
        main: Deck.fromJson(json['main']),
    );

    Map<String, dynamic> toJson() => {
        'main': main.toJson(),
    };
}

class Links {
    Links({
        this.self,
    });

    String self;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        self: json['self'],
    );

    Map<String, dynamic> toJson() => {
        'self': self,
    };
}

class Meta {
    Meta({
        this.language,
        this.originalDocId,
        this.properties,
        this.problems,
        this.metrics,
        this.codeSets,
        this.keywords,
        this.source,
        this.parserVersion,
    });

    Language language;
    String originalDocId;
    List<Property> properties;
    List<dynamic> problems;
    Metrics metrics;
    List<CodeSet> codeSets;
    List<dynamic> keywords;
    Publisher source;
    String parserVersion;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        language: Language.fromJson(json['language']),
        originalDocId: json['original_doc_id'],
        properties: List<Property>.from(json['properties'].map((x) => Property.fromJson(x))),
        problems: List<dynamic>.from(json['problems'].map((x) => x)),
        metrics: Metrics.fromJson(json['metrics']),
        codeSets: List<CodeSet>.from(json['code_sets'].map((x) => CodeSet.fromJson(x))),
        keywords: List<dynamic>.from(json['keywords'].map((x) => x)),
        source: Publisher.fromJson(json['source']),
        parserVersion: json['parser_version'],
    );

    Map<String, dynamic> toJson() => {
        'language': language.toJson(),
        'original_doc_id': originalDocId,
        'properties': List<dynamic>.from(properties.map((x) => x.toJson())),
        'problems': List<dynamic>.from(problems.map((x) => x)),
        'metrics': metrics.toJson(),
        'code_sets': List<dynamic>.from(codeSets.map((x) => x.toJson())),
        'keywords': List<dynamic>.from(keywords.map((x) => x)),
        'source': source.toJson(),
        'parser_version': parserVersion,
    };
}

class CodeSet {
    CodeSet({
        this.type,
        this.id,
        this.codes,
    });

    String type;
    String id;
    List<Code> codes;

    factory CodeSet.fromJson(Map<String, dynamic> json) => CodeSet(
        type: json['type'],
        id: json['id'],
        codes: List<Code>.from(json['codes'].map((x) => Code.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'codes': List<dynamic>.from(codes.map((x) => x.toJson())),
    };
}

class Code {
    Code({
        this.codeschema,
        this.chartingsymbol,
        this.code,
        this.significance,
        this.descriptor,
    });

    Codeschema codeschema;
    String chartingsymbol;
    String code;
    Significance significance;
    String descriptor;

    factory Code.fromJson(Map<String, dynamic> json) => Code(
        codeschema: codeschemaValues.map[json['codeschema']],
        chartingsymbol: json['chartingsymbol'],
        code: json['code'],
        significance: json['significance'] == null ? null : significanceValues.map[json['significance']],
        descriptor: json['descriptor'],
    );

    Map<String, dynamic> toJson() => {
        'codeschema': codeschemaValues.reverse[codeschema],
        'chartingsymbol': chartingsymbol,
        'code': code,
        'significance': significance == null ? null : significanceValues.reverse[significance],
        'descriptor': descriptor,
    };
}

enum Codeschema { DJID, DJN }

final codeschemaValues = EnumValues({
    'DJID': Codeschema.DJID,
    'DJN': Codeschema.DJN
});

enum Significance { MENTION, ABOUT }

final significanceValues = EnumValues({
    'About': Significance.ABOUT,
    'Mention': Significance.MENTION
});

class Language {
    Language({
        this.code,
    });

    String code;

    factory Language.fromJson(Map<String, dynamic> json) => Language(
        code: json['code'],
    );

    Map<String, dynamic> toJson() => {
        'code': code,
    };
}

class Metrics {
    Metrics({
        this.paragraphCount,
        this.characterCount,
        this.wordCount,
        this.imageCount,
        this.videoCount,
        this.chartCount,
        this.audioCount,
    });

    int paragraphCount;
    int characterCount;
    int wordCount;
    int imageCount;
    int videoCount;
    int chartCount;
    int audioCount;

    factory Metrics.fromJson(Map<String, dynamic> json) => Metrics(
        paragraphCount: json['paragraph_count'],
        characterCount: json['character_count'],
        wordCount: json['word_count'],
        imageCount: json['image_count'],
        videoCount: json['video_count'],
        chartCount: json['chart_count'],
        audioCount: json['audio_count'],
    );

    Map<String, dynamic> toJson() => {
        'paragraph_count': paragraphCount,
        'character_count': characterCount,
        'word_count': wordCount,
        'image_count': imageCount,
        'video_count': videoCount,
        'chart_count': chartCount,
        'audio_count': audioCount,
    };
}

class Property {
    Property({
        this.type,
        this.symbol,
        this.codeType,
        this.properties,
    });

    String type;
    String symbol;
    String codeType;
    PropertyProperties properties;

    factory Property.fromJson(Map<String, dynamic> json) => Property(
        type: json['type'],
        symbol: json['symbol'],
        codeType: json['codeType'],
        properties: PropertyProperties.fromJson(json['properties']),
    );

    Map<String, dynamic> toJson() => {
        'type': type,
        'symbol': symbol,
        'codeType': codeType,
        'properties': properties.toJson(),
    };
}

class PropertyProperties {
    PropertyProperties({
        this.topicid,
        this.author,
        this.name,
        this.rank,
        this.id,
        this.extractedtext,
    });

    String topicid;
    String author;
    String name;
    String rank;
    String id;
    String extractedtext;

    factory PropertyProperties.fromJson(Map<String, dynamic> json) => PropertyProperties(
        topicid: json['topicid'],
        author: json['author'],
        name: json['name'],
        rank: json['rank'],
        id: json['id'],
        extractedtext: json['extractedtext'],
    );

    Map<String, dynamic> toJson() => {
        'topicid': topicid,
        'author': author,
        'name': name,
        'rank': rank,
        'id': id,
        'extractedtext': extractedtext,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap ??= map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
