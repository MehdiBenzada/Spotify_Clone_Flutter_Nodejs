require('dotenv').config();
const connectDB = require('./config/dbconn');
const Album = require('./model/Album');
const Song = require('./model/Song');

// 15 distinct royalty-free MP3s from SoundHelix (no login, direct download)
const AUDIO = [
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3',
  'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3',
];

const albums = [
  {
    AlbumTitle: 'ASTROWORLD',
    Artist: 'Travis Scott',
    Photo: 'https://upload.wikimedia.org/wikipedia/en/7/78/Travis_Scott_Astroworld.jpg',
    songs: [
      { SongTitle: 'STARGAZING', Artist: 'Travis Scott' },
      { SongTitle: 'CAROUSEL', Artist: 'Travis Scott' },
      { SongTitle: 'SICKO MODE', Artist: 'Travis Scott' },
    ],
  },
  {
    AlbumTitle: 'After Hours',
    Artist: 'The Weeknd',
    Photo: 'https://upload.wikimedia.org/wikipedia/en/c/c1/The_Weeknd_-_After_Hours.png',
    songs: [
      { SongTitle: 'Blinding Lights', Artist: 'The Weeknd' },
      { SongTitle: 'Save Your Tears', Artist: 'The Weeknd' },
      { SongTitle: 'After Hours', Artist: 'The Weeknd' },
    ],
  },
  {
    AlbumTitle: 'Take Care',
    Artist: 'Drake',
    Photo: 'https://upload.wikimedia.org/wikipedia/en/a/a7/Drake_-_Take_Care_%28Official_Album_Cover%29.jpg',
    songs: [
      { SongTitle: "Marvins Room", Artist: 'Drake' },
      { SongTitle: 'Take Care', Artist: 'Drake' },
      { SongTitle: 'Headlines', Artist: 'Drake' },
    ],
  },
  {
    AlbumTitle: 'DAMN.',
    Artist: 'Kendrick Lamar',
    Photo: 'https://upload.wikimedia.org/wikipedia/en/5/51/Kendrick_Lamar_-_Damn.png',
    songs: [
      { SongTitle: 'HUMBLE.', Artist: 'Kendrick Lamar' },
      { SongTitle: 'DNA.', Artist: 'Kendrick Lamar' },
      { SongTitle: 'LOVE.', Artist: 'Kendrick Lamar' },
    ],
  },
  {
    AlbumTitle: '2014 Forest Hills Drive',
    Artist: 'J. Cole',
    Photo: 'https://upload.wikimedia.org/wikipedia/en/5/5d/2014_Forest_Hills_Drive_album_cover.jpg',
    songs: [
      { SongTitle: 'No Role Modelz', Artist: 'J. Cole' },
      { SongTitle: 'G.O.M.D.', Artist: 'J. Cole' },
      { SongTitle: 'Love Yourz', Artist: 'J. Cole' },
    ],
  },
];

async function seed() {
  await connectDB();

  console.log('Clearing existing data...');
  await Song.deleteMany({});
  await Album.deleteMany({});

  let audioIndex = 0;
  for (const albumDef of albums) {
    const songDocs = await Song.insertMany(
      albumDef.songs.map(s => ({
        SongTitle: s.SongTitle,
        Artist: s.Artist,
        Photo: albumDef.Photo,
        url: AUDIO[audioIndex++],
      }))
    );

    await Album.create({
      AlbumTitle: albumDef.AlbumTitle,
      Artist: albumDef.Artist,
      Photo: albumDef.Photo,
      Songs: songDocs.map(s => s._id),
    });

    console.log(`✓ ${albumDef.Artist} — ${albumDef.AlbumTitle}`);
  }

  console.log('\n5 albums seeded successfully.');
  process.exit(0);
}

seed().catch(err => {
  console.error('Seed failed:', err);
  process.exit(1);
});
